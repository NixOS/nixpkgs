###### Description of changes

<!--
For package updates please link to a changelog or describe changes, this helps your fellow maintainers discover breaking updates.
For new packages please briefly describe the package or provide a link to its homepage.
-->

###### Things done

<!-- Please check what applies. Note that these are not hard requirements but merely serve as information for reviewers. -->

- Built on platform(s)
  - [ ] x86_64-linux
  - [ ] aarch64-linux
  - [ ] x86_64-darwin
  - [ ] aarch64-darwin
- [ ] For non-Linux: Is `sandbox = true` set in `nix.conf`? (See [Nix manual](https://nixos.org/manual/nix/stable/command-ref/conf-file.html))
- [ ] Tested, as applicable:
  - [NixOS test(s)](https://nixos.org/manual/nixos/unstable/index.html#sec-nixos-tests) (look inside [nixos/tests](https://github.com/NixOS/nixpkgs/blob/master/nixos/tests))
  - and/or [package tests](https://nixos.org/manual/nixpkgs/unstable/#sec-package-tests)
  - or, for functions and "core" functionality, tests in [lib/tests](https://github.com/NixOS/nixpkgs/blob/master/lib/tests) or [pkgs/test](https://github.com/NixOS/nixpkgs/blob/master/pkgs/test)
  - made sure NixOS tests are [linked](https://nixos.org/manual/nixpkgs/unstable/#ssec-nixos-tests-linking) to the relevant packages
- [ ] Tested compilation of all packages that depend on this change using `nix-shell -p nixpkgs-review --run "nixpkgs-review rev HEAD"`. Note: all changes have to be committed, also see [nixpkgs-review usage](https://github.com/Mic92/nixpkgs-review#usage)
- [ ] Tested basic functionality of all binary files (usually in `./result/bin/`)
- [22.11 Release Notes (or backporting 22.05 Release notes)](https://github.com/NixOS/nixpkgs/blob/master/CONTRIBUTING.md#generating-2211-release-notes)
  - [ ] (Package updates) Added a release notes entry if the change is major or breaking
  - [ ] (Module updates) Added a release notes entry if the change is significant
  - [ ] (Module addition) Added a release notes entry if adding a new NixOS module
  - [ ] (Release notes changes) Ran `nixos/doc/manual/md-to-db.sh` to update generated release notes
- [ ] Fits [CONTRIBUTING.md](https://github.com/NixOS/nixpkgs/blob/master/CONTRIBUTING.md).

<!--
To help with the large amounts of pull requests, we would appreciate your
reviews of other pull requests, especially simple package updates. Just leave a
comment describing what you have tested in the relevant package/service.
Reviewing helps to reduce the average time-to-merge for everyone.
Thanks a lot if you do!

List of open PRs: https://github.com/NixOS/nixpkgs/pulls
Reviewing guidelines: https://nixos.org/manual/nixpkgs/unstable/#chap-reviewing-contributions
-->
