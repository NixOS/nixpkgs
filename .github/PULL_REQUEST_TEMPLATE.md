###### Motivation for this change


###### Things done

- [ ] Tested using sandboxing
  ([nix.useSandbox](http://nixos.org/nixos/manual/options.html#opt-nix.useSandbox) on NixOS,
    or option `build-use-sandbox` in [`nix.conf`](http://nixos.org/nix/manual/#sec-conf-file)
    on non-NixOS)
- Built on platform(s)
   - [ ] NixOS
   - [ ] macOS
   - [ ] Linux
- [ ] Tested via one or more NixOS test(s) if existing and applicable for the change (look inside [nixos/tests](https://github.com/NixOS/nixpkgs/blob/master/nixos/tests))
- [ ] Tested compilation of all pkgs that depend on this change using `nix-shell -p nox --run "nox-review wip"`
- [ ] Tested execution of all binary files (usually in `./result/bin/`)
- [ ] Fits [CONTRIBUTING.md](https://github.com/NixOS/nixpkgs/blob/master/.github/CONTRIBUTING.md).

---

