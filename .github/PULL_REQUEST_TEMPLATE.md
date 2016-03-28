###### Things done:

- [ ] Tested using sandboxing (`nix-build --option build-use-chroot true` or [nix.useChroot](http://nixos.org/nixos/manual/options.html#opt-nix.useChroot) on NixOS)
- Built on platform(s)
   - [ ] NixOS
   - [ ] OS X
   - [ ] Linux
- [ ] Tested compilation of all pkgs that depend on this change using `nix-shell -p nox --run "nox-review wip"`
- [ ] Tested execution of all binary files (usually in `./result/bin/`)
- [ ] Fits [CONTRIBUTING.md](https://github.com/NixOS/nixpkgs/blob/master/.github/CONTRIBUTING.md).

###### More

Fixes issue #<insert id>

cc @<maintainer>


---

_Please note, that points are not mandatory, but rather desired._
