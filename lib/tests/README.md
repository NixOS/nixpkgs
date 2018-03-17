# lib tests

Here you can find tests for the library.

* Tests for the module system are defined in `./modules.sh`.
* Tests for most other library functions are defined in `./misc.sh`.

You can build everything by running `nix build -f ./release.nix`, though calling
test suites directly is considerably faster. Consult the files listed above to
find out how to do that.

