#
# Build
#

BASIC_FILES = \
		src/header.js \
		src/system/class.js \
		src/system/_writer.js \
		src/system/_types.js \
		src/system/error.js \
		src/system/set.js \
		src/system/values.js \
		src/system/pair.js \
		src/system/symbol.js \
		src/system/char.js \
		src/system/number.js \
		src/system/port.js \
		src/system/record.js \
		src/system/enumeration.js \
		src/system/hashtable.js \
		src/system/syntax.js \
		src/system/parser.js \
		src/system/compiler.js \
		src/system/pause.js \
		src/system/call.js \
		src/system/interpreter.js \
		src/system/promise.js \
		src/library/infra.js \
		src/library/r6rs_lib.js \
		src/library/js_interface.js \
		src/library/extra_lib.js \
		src/library/node_functions.js \
		src/library/srfi.js \
		$()
PLAIN_FILES = \
		src/version.js \
		src/header.js \
		src/system/class.js \
		src/system/_writer.js \
		src/system/_types.js \
		src/system/error.js \
		src/system/set.js \
		src/system/values.js \
		src/system/pair.js \
		src/system/symbol.js \
		src/system/char.js \
		src/system/number.js \
		src/system/port.js \
		src/system/record.js \
		src/system/enumeration.js \
		src/system/hashtable.js \
		src/system/syntax.js \
		src/system/parser.js \
		src/system/compiler.js \
		src/system/pause.js \
		src/system/call.js \
		src/system/interpreter.js \
		src/system/promise.js \
		src/library/infra.js \
		src/library/r6rs_lib.js \
		src/library/js_interface.js \
		src/library/extra_lib.js \
		src/library/node_functions.js \
		src/library/srfi.js \
		src/library/webscheme_lib.js \
		src/platforms/browser/dumper.js \
		src/platforms/browser/console.js \
		src/platforms/browser/release_initializer.js \
		$()
BROWSER_FILES = \
		src/version.js \
		src/deps/jquery.js \
		src/deps/underscore.js \
		src/deps/underscore.string.js \
		src/header.js \
		src/system/class.js \
		src/system/_writer.js \
		src/system/_types.js \
		src/system/error.js \
		src/system/set.js \
		src/system/values.js \
		src/system/pair.js \
		src/system/symbol.js \
		src/system/char.js \
		src/system/number.js \
		src/system/port.js \
		src/system/record.js \
		src/system/enumeration.js \
		src/system/hashtable.js \
		src/system/syntax.js \
		src/system/parser.js \
		src/system/compiler.js \
		src/system/pause.js \
		src/system/call.js \
		src/system/interpreter.js \
		src/system/promise.js \
		src/library/infra.js \
		src/library/r6rs_lib.js \
		src/library/js_interface.js \
		src/library/extra_lib.js \
		src/library/node_functions.js \
		src/library/srfi.js \
		src/library/webscheme_lib.js \
		src/platforms/browser/dumper.js \
		src/platforms/browser/console.js \
		src/platforms/browser/release_initializer.js \
		$()

all: build

build: \
	package.json \
	src/development_initializer.js \
	release/biwascheme.js \
	release/biwascheme-min.js \
	release/biwascheme-plain.js \
	release/biwascheme-plain-min.js

FILES.json: FILES.json.ejs
	`npm bin`/ejs-cli FILES.json.ejs > $@

package.json: package.json.ejs FILES.json
	`npm bin`/ejs-cli package.json.ejs > $@

src/development_initializer.js: src/development_initializer.js.ejs FILES.json
	`npm bin`/ejs-cli src/development_initializer.js.ejs > $@

src/version.js: src/version.js.in VERSION
	cat $< | sed -e "s/@GIT_COMMIT@/`git log -1 --pretty=format:%H`/" | sed -e "s/@VERSION@/`cat VERSION`/" > $@

release/biwascheme.js: $(BROWSER_FILES)
	cat $(BROWSER_FILES) > $@
	@echo "Wrote " $@

release/biwascheme-min.js: release/biwascheme.js
	`npm bin`/uglifyjs -o $@ release/biwascheme.js --comments
	@echo "Wrote " $@

release/biwascheme-plain.js: $(PLAIN_FILES)
	cat $(PLAIN_FILES) > $@
	@echo "Wrote " $@

release/biwascheme-plain-min.js: release/biwascheme-plain.js
	`npm bin`/uglifyjs -o $@ release/biwascheme-plain.js --comments
	@echo "Wrote " $@

#
# Test
#

browser_test:
	cd test/browser_functions; node ./server.js

#
# Website
#

index.html: doc/_header.html index_.html doc/_footer.html
	cat doc/_header.html index_.html doc/_footer.html > index.html

website: index.html
	node bin/biwas tools/make_doc.scm

watch_website:
	ifchanged -d 'make website -B' doc/**/*.md doc/_*



