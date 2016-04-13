# How to contribute

Note: contributing implies licensing those contributions
under the terms of [COPYING](../COPYING), which is an MIT-like license.

## Opening issues

* Make sure you have a [GitHub account](https://github.com/signup/free)
* [Submit an issue](https://github.com/NixOS/nixpkgs/issues) - assuming one does not already exist.
  * Clearly describe the issue including steps to reproduce when it is a bug.
  * Include information what version of nixpkgs and Nix are you using (nixos-version or git revision).

## Submitting changes

* Format the commits in the following way:

  `(pkg-name | service-name): (from -> to | init at version | refactor | etc)`

  Examples:

  * nginx: init at 2.0.1
  * firefox: 3.0 -> 3.1.1
  * hydra service: add bazBaz option
  * nginx service: refactor config generation

* `meta.description` should:
  * Be capitalized
  * Not start with the package name
  * Not have a dot at the end

See the nixpkgs manual for more details on how to [Submit changes to nixpkgs](http://hydra.nixos.org/job/nixpkgs/trunk/manual/latest/download-by-type/doc/manual#chap-submitting-changes).

