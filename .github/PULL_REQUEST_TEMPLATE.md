
<!--
^ Please summarise the changes you have done and explain why they are necessary here ^

For package updates please link to a changelog or describe changes, this helps your fellow maintainers discover breaking updates.
For new packages please briefly describe the package or provide a link to its homepage.
-->

## Things done

<!-- Please check what applies. Note that these are not hard requirements but merely serve as information for reviewers. -->

- Built on platform(s)
  - [ ] x86_64-linux
  - [ ] aarch64-linux
  - [ ] x86_64-darwin
  - [ ] aarch64-darwin
- [ ] Tested, as applicable:
  - [NixOS test(s)] (look inside [nixos/tests])
  - and/or [package tests]
  - or, for functions and "core" functionality, tests in [lib/tests] or [pkgs/test]
  - made sure NixOS tests are [linked] to the relevant packages
- [ ] Tested compilation of all packages that depend on this change using `nix-shell -p nixpkgs-review --run "nixpkgs-review rev HEAD"`. Note: all changes have to be committed, also see [nixpkgs-review usage]
- [ ] Tested basic functionality of all binary files (usually in `./result/bin/`)
- Nixpkgs Release Notes (or backporting 25.05 Nixpkgs Release notes)
  - [ ] (Package updates) Added a release notes entry if the change is major or breaking
- NixOS Release Notes (or backporting 25.05 NixOS Release notes)
  - [ ] (Module updates) Added a release notes entry if the change is significant
  - [ ] (Module addition) Added a release notes entry if adding a new NixOS module
- [ ] Fits [CONTRIBUTING.md], [pkgs/README.md], [maintainers/README.md] and other contributing documentation in corresponding paths.

[NixOS test(s)]: https://nixos.org/manual/nixos/unstable/index.html#sec-nixos-tests
[package tests]: https://github.com/NixOS/nixpkgs/blob/master/pkgs/README.md#package-tests
[linked]: https://github.com/NixOS/nixpkgs/blob/master/pkgs/README.md#linking-nixos-module-tests-to-a-package
[nixpkgs-review usage]: https://github.com/Mic92/nixpkgs-review#usage

[CONTRIBUTING.md]: https://github.com/NixOS/nixpkgs/blob/master/CONTRIBUTING.md
[lib/tests]: https://github.com/NixOS/nixpkgs/blob/master/lib/tests
[maintainers/README.md]: https://github.com/NixOS/nixpkgs/blob/master/maintainers/README.md
[nixos/tests]: https://github.com/NixOS/nixpkgs/blob/master/nixos/tests
[pkgs/README.md]: https://github.com/NixOS/nixpkgs/blob/master/pkgs/README.md
[pkgs/test]: https://github.com/NixOS/nixpkgs/blob/master/pkgs/test

---

Add a :+1: [reaction] to [pull requests you find important].

[reaction]: https://github.blog/2016-03-10-add-reactions-to-pull-requests-issues-and-comments/
[pull requests you find important]: https://github.com/NixOS/nixpkgs/pulls?q=is%3Aopen+sort%3Areactions-%2B1-desc
