
<!--
^ Please summarise the changes you have done and explain why they are necessary here ^

For package updates please link to a changelog or describe changes, this helps your fellow maintainers discover breaking updates.
For new packages please briefly describe the package or provide a link to its homepage.
-->

## Things done

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
Please check what applies. Note that these are not hard requirements but merely serve as information for reviewers.
However, please do not remove the template, even when nothing is checked!
-->

- [ ] Fits [CONTRIBUTING.md], [pkgs/README.md], [maintainers/README.md] and other READMEs.
- [ ] Follows the [automation/AI policy].
- Built on platform:
  - [ ] x86_64-linux
  - [ ] aarch64-linux
  - [ ] aarch64-darwin
- Tested, as applicable:
  - [ ] Basic functionality of all binary files, usually in `./result/bin/`.
  - [ ] Ran `nixpkgs-review` on this PR. See [nixpkgs-review usage].
  - [ ] [Package tests] at `passthru.tests`.
  - [ ] [NixOS tests] in [nixos/tests].
  - [ ] Tests in [lib/tests] or [pkgs/test] for functions and "core" functionality.
- Nixpkgs Release Notes
  - [ ] Package update: when the change is major or breaking.
- NixOS Release Notes
  - [ ] Module addition: when adding a new NixOS module.
  - [ ] Module update: when the change is significant.

[Package tests]: https://github.com/NixOS/nixpkgs/blob/master/pkgs/README.md#package-tests
[NixOS tests]: https://nixos.org/manual/nixos/unstable/index.html#sec-nixos-tests
[nixpkgs-review usage]: https://github.com/Mic92/nixpkgs-review#usage

[CONTRIBUTING.md]: https://github.com/NixOS/nixpkgs/blob/master/CONTRIBUTING.md
[automation/AI policy]: https://github.com/NixOS/nixpkgs/blob/master/CONTRIBUTING.md#automationai-policy
[lib/tests]: https://github.com/NixOS/nixpkgs/blob/master/lib/tests
[maintainers/README.md]: https://github.com/NixOS/nixpkgs/blob/master/maintainers/README.md
[nixos/tests]: https://github.com/NixOS/nixpkgs/blob/master/nixos/tests
[pkgs/README.md]: https://github.com/NixOS/nixpkgs/blob/master/pkgs/README.md
[pkgs/test]: https://github.com/NixOS/nixpkgs/blob/master/pkgs/test
