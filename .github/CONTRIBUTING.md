# How to contribute

Note: contributing implies licensing those contributions
under the terms of [COPYING](../COPYING), which is an MIT-like license.

## Opening issues

* Make sure you have a [GitHub account](https://github.com/signup/free)
* Make sure there is no open issue on the topic
* [Submit a new issue](https://github.com/NixOS/nixpkgs/issues/new/choose) by choosing the kind of topic and fill out the template

## Submitting changes

* Format the commit messages in the following way:

  ```
  (pkg-name | nixos/<module>): (from -> to | init at version | refactor | etc)

  (Motivation for change. Additional information.)
  ```

  For consistency, there should not be a period at the end of the commit message's summary line (the first line of the commit message).

  Examples:

  * nginx: init at 2.0.1
  * firefox: 54.0.1 -> 55.0
  * nixos/hydra: add bazBaz option

    Dual baz behavior is needed to do foo.
  * nixos/nginx: refactor config generation

    The old config generation system used impure shell scripts and could break in specific circumstances (see #1234).

* `meta.description` should:
  * Be capitalized.
  * Not start with the package name.
  * Not have a period at the end.
* `meta.license` must be set and fit the upstream license.
  * If there is no upstream license, `meta.license` should default to `stdenv.lib.licenses.unfree`.
* `meta.maintainers` must be set.

See the nixpkgs manual for more details on [standard meta-attributes](https://nixos.org/nixpkgs/manual/#sec-standard-meta-attributes) and on how to [submit changes to nixpkgs](https://nixos.org/nixpkgs/manual/#chap-submitting-changes).

## Writing good commit messages

In addition to writing properly formatted commit messages, it's important to include relevant information so other developers can later understand *why* a change was made. While this information usually can be found by digging code, mailing list/Discourse archives, pull request discussions or upstream changes, it may require a lot of work.

For package version upgrades and such a one-line commit message is usually sufficient.

## Backporting changes

To [backport a change into a release branch](https://nixos.org/nixpkgs/manual/#submitting-changes-stable-release-branches):

1. Take note of the commit in which the change was introduced into `master`.
2. Check out the target _release branch_, e.g. `release-20.03`. Do not use a _channel branch_ like `nixos-20.03` or `nixpkgs-20.03`.
3. Use `git cherry-pick -x <original commit>`.
4. Open your backport PR. Make sure to select the release branch (e.g. `release-20.03`) as the target branch of the PR, and link to the PR in which the original change was made to `master`.

## Reviewing contributions

See the nixpkgs manual for more details on how to [Review contributions](https://nixos.org/nixpkgs/manual/#chap-reviewing-contributions).
