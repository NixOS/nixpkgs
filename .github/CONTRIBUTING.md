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

  ```
  (pkg-name | nixos/<module>): (from -> to | init at version | refactor | etc)
  
  (Motivation for change. Additional information.)
  ```

  Examples:

  * nginx: init at 2.0.1
  * firefox: 3.0 -> 3.1.1
  * nixos/hydra: add bazBaz option
  
    Dual baz behavior is needed to do foo.
  * nixos/nginx: refactor config generation
    
    The old config generation system used impure shell scripts and could break in specific circumstances (see #1234).

* `meta.description` should:
  * Be capitalized
  * Not start with the package name
  * Not have a dot at the end

See the nixpkgs manual for more details on how to [Submit changes to nixpkgs](https://nixos.org/nixpkgs/manual/#chap-submitting-changes).

## Writing good commit messages

In addition to writing properly formatted commit messages, it's important to include relevant information so other developers can later understand *why* a change was made. While this information usually can be found by digging code, mailing list archives, pull request discussions or upstream changes, it may require a lot of work.

For package version upgrades and such a one-line commit message is usually sufficient.

## Reviewing contributions

See the nixpkgs manual for more details on how to [Review contributions](https://nixos.org/nixpkgs/manual/#sec-reviewing-contributions).
