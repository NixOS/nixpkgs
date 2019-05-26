<!-- Nixpkgs has a lot of new incoming Pull Requests, but not enough people to review this constant stream. Even if you aren't a committer, we would appreciate reviews of other PRs, especially simple ones like package updates. Just testing the relevant package/service and leaving a comment saying what you tested, how you tested it and whether it worked would be great. List of open PRs: <https://github.com/NixOS/nixpkgs/pulls>, for more about reviewing contributions: <https://hydra.nixos.org/job/nixpkgs/trunk/manual/latest/download/1/nixpkgs/manual.html#sec-reviewing-contributions>. Reviewing isn't mandatory, but it would help out a lot and reduce the average time-to-merge for all of us. Thanks a lot if you do! -->
###### Motivation for this change


###### Things done

<!-- Please check what applies. Note that these are not hard requirements but merely serve as information for reviewers. -->

- [ ] Tested using sandboxing ([nix.useSandbox](http://nixos.org/nixos/manual/options.html#opt-nix.useSandbox) on NixOS, or option `sandbox` in [`nix.conf`](http://nixos.org/nix/manual/#sec-conf-file) on non-NixOS)
- Built on platform(s)
   - [ ] NixOS
   - [ ] macOS
   - [ ] other Linux distributions
- [ ] Tested via one or more NixOS test(s) if existing and applicable for the change (look inside [nixos/tests](https://github.com/NixOS/nixpkgs/blob/master/nixos/tests))
- [ ] Tested compilation of all pkgs that depend on this change using `nix-shell -p nix-review --run "nix-review wip"`
- [ ] Tested execution of all binary files (usually in `./result/bin/`)
- [ ] Determined the impact on package closure size (by running `nix path-info -S` before and after)
- [ ] Assured whether relevant documentation is up to date
- [ ] Fits [CONTRIBUTING.md](https://github.com/NixOS/nixpkgs/blob/master/.github/CONTRIBUTING.md).

---
