<!--
To help with the large amounts of pull requests, we would appreciate your
reviews of other pull requests, especially simple package updates.

You can start by reviewing packages on your platform to complement the
author's platform (see steps below).

List of open PRs: https://github.com/NixOS/nixpkgs/pulls
Marvin needs_reviewer: https://github.com/NixOS/nixpkgs/pulls?q=is%3Apr+is%3Aopen+label%3Aneeds_reviewer+
Marvin needs_merger: https://github.com/NixOS/nixpkgs/pulls?q=is%3Apr+is%3Aopen+label%3Aneeds_merger+

Reviewing guidelines: https://hydra.nixos.org/job/nixpkgs/trunk/manual/latest/download/1/nixpkgs/manual.html#chap-reviewing-contributions
-->

###### Motivation for this change


###### Things done

<!-- 
It is strongly suggested to use `nipkgs-review`:
- install `nixpkgs-review` for good with `nix-env -f '<nixpkgs>' -iA nixpkgs-review`
- consult usage documentation: https://github.com/Mic92/nixpkgs-review#usage
-->

- [ ] Tested sucessful build of final PR `nixpkgs-review pr <pr-number>`.
      If suceeded, within the resulting `nix-shell`:
   - [ ] Manually tested execution of all binary files (in `./results/bin/`)
   - [ ] Mentioned the manual checks and validations at the end of generated `./report.md`
   - [ ] If ok, posted the results: `nix-shell> nixpkgs-review post-result`

- Platform(s), I built on (reviewers, please complement!):
<!-- more is better, reviewers might complement -->
   - [ ] NixOS
   - [ ] macOS
   - [ ] other Linux distributions (Ubuntu, Arch Linux, Alpine, etc.).

- [ ] If available: tested via one or more NixOS test(s) `nixpkgs-review pr -p nixosTests.<test> <package> <pr-number>` (look inside [nixos/tests](https://github.com/NixOS/nixpkgs/blob/master/nixos/tests)
<!-- Note, that only few tests are available, if you'd want to write your own have a look at: https://github.com/NixOS/nixpkgs/issues/34987 and furthermore read through https://nixos.org/nixos/manual/index.html#sec-nixos-tests. Looking through the source code should be helpful, as well. -->

- [ ] Ensured that relevant documentation is up to date

- [ ] Fits [CONTRIBUTING.md](https://github.com/NixOS/nixpkgs/blob/master/.github/CONTRIBUTING.md).
