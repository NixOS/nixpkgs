
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
- For non-Linux: Is sandboxing enabled in `nix.conf`? (See [Nix manual](https://nixos.org/manual/nix/stable/command-ref/conf-file.html))
  - [ ] `sandbox = relaxed`
  - [ ] `sandbox = true`
- [ ] Tested, as applicable:
  - [NixOS test(s)](https://nixos.org/manual/nixos/unstable/index.html#sec-nixos-tests) (look inside [nixos/tests](https://github.com/NixOS/nixpkgs/blob/master/nixos/tests))
  - and/or [package tests](https://github.com/NixOS/nixpkgs/blob/master/pkgs/README.md#package-tests)
  - or, for functions and "core" functionality, tests in [lib/tests](https://github.com/NixOS/nixpkgs/blob/master/lib/tests) or [pkgs/test](https://github.com/NixOS/nixpkgs/blob/master/pkgs/test)
  - made sure NixOS tests are [linked](https://github.com/NixOS/nixpkgs/blob/master/pkgs/README.md#linking-nixos-module-tests-to-a-package) to the relevant packages
- [ ] Tested compilation of all packages that depend on this change using `nix-shell -p nixpkgs-review --run "nixpkgs-review rev HEAD"`. Note: all changes have to be committed, also see [nixpkgs-review usage](https://github.com/Mic92/nixpkgs-review#usage)
- [ ] Tested basic functionality of all binary files (usually in `./result/bin/`)
- [Nixpkgs 25.11 Release Notes](https://github.com/NixOS/nixpkgs/blob/master/doc/release-notes/rl-2511.section.md) (or backporting [25.05](https://github.com/NixOS/nixpkgs/blob/master/doc/manual/release-notes/rl-2505.section.md) Nixpkgs Release notes)
  - [ ] (Package updates) Added a release notes entry if the change is major or breaking
- [NixOS 25.11 Release Notes](https://github.com/NixOS/nixpkgs/blob/master/nixos/doc/manual/release-notes/rl-2511.section.md) (or backporting [25.05](https://github.com/NixOS/nixpkgs/blob/master/nixos/doc/manual/release-notes/rl-2505.section.md) NixOS Release notes)
  - [ ] (Module updates) Added a release notes entry if the change is significant
  - [ ] (Module addition) Added a release notes entry if adding a new NixOS module
- [ ] Fits [CONTRIBUTING.md](https://github.com/NixOS/nixpkgs/blob/master/CONTRIBUTING.md), [pkgs/README.md](https://github.com/NixOS/nixpkgs/blob/master/pkgs/README.md), [maintainers/README.md](https://github.com/NixOS/nixpkgs/blob/master/maintainers/README.md) and other contributing documentation in corresponding paths.

###### Getting started with reviewing this package

<!--
Put in this section any additional comment that might help potential reviewers to review your PR. Describe for instance:
- If you expect the PR to be simple to review or not (say if it's just a simple package update with few dependencies, or a package with many dependencies that have high chances to cause breakage). This can help reviewiers to easily identify PR that can be merged quickly.
- The instructions to check if the bug is fixed etc, which binary should be used to start the program, which command can be run to check basic functionalities... This can help people unexperienced with the software to get started.
Make sure to update the placeholders in the intructions below (in upper case letter). Note that you might need to first submit the PR and then edit it to change PUT_HERE_THE_PR_NUMBER_CF_URL.
-->

To start reviewing this PR, you can first run [nixpkgs-review](https://github.com/Mic92/nixpkgs-review):
```
$ # first cd to a clone of nixpkgs, or clone it, e.g. in your $HOME: git clone https://github.com/NixOS/nixpkgs
$ nix run nixpkgs#nixpkgs-review -- pr PUT_HERE_THE_PR_NUMBER_CF_URL
```

Then, basic functionalities can be tested using:
```
$ ./result/YOUR_PROGRAM/bin/YOUR_BINARY
```

<!--
To help with the large amounts of pull requests, we would appreciate your
reviews of other pull requests, especially simple package updates. Just leave a
comment describing what you have tested in the relevant package/service.
Reviewing helps to reduce the average time-to-merge for everyone.
Thanks a lot if you do!

List of open PRs: https://github.com/NixOS/nixpkgs/pulls
Reviewing guidelines: https://github.com/NixOS/nixpkgs/blob/master/pkgs/README.md#reviewing-contributions
-->

---

Add a :+1: [reaction] to [pull requests you find important].

[reaction]: https://github.blog/2016-03-10-add-reactions-to-pull-requests-issues-and-comments/
[pull requests you find important]: https://github.com/NixOS/nixpkgs/pulls?q=is%3Aopen+sort%3Areactions-%2B1-desc
