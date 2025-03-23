# Building Images with `nixos-rebuild build-image` {#sec-image-nixos-rebuild-build-image}

Nixpkgs contains a variety of modules to build custom images for different virtualization platforms and cloud providers, such as e.g. `amazon-image.nix` and `proxmox-lxc.nix`.

While those can be imported individually, `system.build.images` provides an attribute set mapping variant names to image derivations. Available variants are defined - end extendable - in `image.modules`, an attribute set mapping variant names to a list of NixOS modules.

All of those images can be built via both, their `system.build.image` attribute, and the CLI `nixos-rebuild build-image`. To build i.e. an Amazon image from your existing NixOS configuration:

```ShellSession
$ nixos-rebuild build-image --image-variant amazon
$ ls result
nixos-image-amazon-25.05pre-git-x86_64-linux.vhd  nix-support
```

To get a list of all variants available, run `nixos-rebuild build-image` without arguments.

