<!--
To help with the large amounts of pull requests, we would appreciate your
reviews of other pull requests, especially simple package updates. Just leave a
comment describing what you have tested in the relevant package/service.
Reviewing helps to reduce the average time-to-merge for everyone.
Thanks a lot if you do!
List of open PRs: https://github.com/NixOS/nixpkgs/pulls
Reviewing guidelines: https://nixos.org/manual/nixpkgs/unstable/#chap-reviewing-contributions
-->

###### Motivation for this change


###### Things done

<!-- Please check what applies. Note that these are not hard requirements but merely serve as information for reviewers. -->

- Built on platform(s)
  - [ ] x86_64-linux
  - [ ] aarch64-linux
  - [ ] x86_64-darwin
  - [ ] aarch64-darwin
- [ ] For non-Linux: Is `sandbox = true` set in `nix.conf`? (See [Nix manual](https://nixos.org/manual/nix/stable/#sec-conf-file))
- [ ] Tested via one or more NixOS test(s) if existing and applicable for the change (look inside [nixos/tests](https://github.com/NixOS/nixpkgs/blob/master/nixos/tests))
- [ ] Tested compilation of all packages that depend on this change using `nix-shell -p nixpkgs-review --run "nixpkgs-review wip"`
- [ ] Tested execution of all binary files (usually in `./result/bin/`)
- [21.11 Release Notes (or backporting 21.05 Release notes)](https://github.com/NixOS/nixpkgs/blob/master/CONTRIBUTING.md#generating-2111-release-notes)
  - [ ] (Package updates) Added a release notes entry if the change is major or breaking
  - [ ] (Module updates) Added a release notes entry if the change is significant
  - [ ] (Module addition) Added a release notes entry if adding a new NixOS module
- [ ] Fits [CONTRIBUTING.md](https://github.com/NixOS/nixpkgs/blob/master/CONTRIBUTING.md).
