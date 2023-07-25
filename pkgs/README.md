# Contributing to Nixpkgs packages

## (Conventions)

* `meta.description` must:
  * Be short, just one sentence.
  * Be capitalized.
  * Not start with the package name.
    * More generally, it should not refer to the package name.
  * Not end with a period (or any punctuation for that matter).
  * Aim to inform while avoiding subjective language.
* `meta.license` must be set and fit the upstream license.
  * If there is no upstream license, `meta.license` should default to `lib.licenses.unfree`.
  * If in doubt, try to contact the upstream developers for clarification.
* `meta.mainProgram` must be set when appropriate.
* `meta.maintainers` should be set.

See the nixpkgs manual for more details on [standard meta-attributes](https://nixos.org/nixpkgs/manual/#sec-standard-meta-attributes).

## Testing changes

To run the main types of tests locally:

- Run package-internal tests with `nix-build --attr pkgs.PACKAGE.passthru.tests`
- Run [NixOS tests](https://nixos.org/manual/nixos/unstable/#sec-nixos-tests) with `nix-build --attr nixosTest.NAME`, where `NAME` is the name of the test listed in `nixos/tests/all-tests.nix`
- Run [global package tests](https://nixos.org/manual/nixpkgs/unstable/#sec-package-tests) with `nix-build --attr tests.PACKAGE`, where `PACKAGE` is the name of the test listed in `pkgs/test/default.nix`
- See `lib/tests/NAME.nix` for instructions on running specific library tests
