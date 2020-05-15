<!--
To help with the large amounts of pull requests, we would appreciate your
reviews of other pull requests, especially simple package updates. Just leave a
comment describing what you have tested in the relevant package/service.
Reviewing helps to reduce the average time-to-merge for everyone.
Thanks a lot if you do!
List of open PRs: https://github.com/NixOS/nixpkgs/pulls
Reviewing guidelines: https://hydra.nixos.org/job/nixpkgs/trunk/manual/latest/download/1/nixpkgs/manual.html#chap-reviewing-contributions
-->

###### Motivation for this change


###### Things done

<!-- Please check what applies. Note that these are not hard requirements but merely serve as information for reviewers. -->

- [ ] Tested using sandboxing ([nix.useSandbox](https://nixos.org/nixos/manual/options.html#opt-nix.useSandbox) on NixOS, or option `sandbox` in [`nix.conf`](https://nixos.org/nix/manual/#sec-conf-file) on non-NixOS linux)
- Built on platform(s)
   - [ ] NixOS
   - [ ] macOS
   - [ ] other Linux distributions
- [ ] Tested via one or more NixOS test(s) if existing and applicable for the change (look inside [nixos/tests](https://github.com/NixOS/nixpkgs/blob/master/nixos/tests))
- [ ] Tested compilation of all pkgs that depend on this change using `nix-shell -p nixpkgs-review --run "nixpkgs-review wip"`
- [ ] Tested execution of all binary files (usually in `./result/bin/`)
- [ ] Determined the impact on package closure size (by running `nix path-info -S` before and after)
- [ ] Ensured that relevant documentation is up to date
- [ ] Fits [CONTRIBUTING.md](https://github.com/NixOS/nixpkgs/blob/master/.github/CONTRIBUTING.md).
