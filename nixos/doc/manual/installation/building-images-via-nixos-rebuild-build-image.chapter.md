# Building Images with `nixos-rebuild build-image` {#sec-image-nixos-rebuild-build-image}

Nixpkgs contains a variety of modules to build custom images for different virtualization platforms and cloud providers, such as e.g. `amazon-image.nix` and `proxmox-lxc.nix`.

While those can be imported directly, `system.build.images` provides an attribute set mapping variant names to image derivations. Available variants are defined - end extendable - in `image.modules`, an attribute set mapping variant names to NixOS modules.

All of those images can be built via both, their `system.build.image` attribute and the `nixos-rebuild build-image` command.

For example, to build an Amazon image from your existing NixOS configuration, run:

```ShellSession
$ nixos-rebuild build-image --image-variant amazon
[...]
Done. The disk image can be found in /nix/store/[hash]-nixos-image-amazon-25.05pre-git-x86_64-linux/nixos-image-amazon-25.05pre-git-x86_64-linux.vpc
```

To get a list of all variants available, run `nixos-rebuild build-image` without arguments.

::: {.example #ex-nixos-rebuild-build-image-customize}

## Customize specific image variants {#sec-image-nixos-rebuild-build-image-customize}

The `image.modules` option can be used to set specific options per image variant, in a similar fashion as [specialisations](options.html#opt-specialisation) for generic NixOS configurations.

E.g. images for the cloud provider Linode use `grub2` as a bootloader by default. If you are using `systemd-boot` on other platforms and want to disable it for Linode only, you could use the following options:

``` nix
{
  image.modules.linode = {
    boot.loader.systemd-boot.enable = lib.mkForce false;
  };
}
```
