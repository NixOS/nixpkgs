# Building Images via `systemd-repart` {#sec-image-repart}

You can build disk images in NixOS with the `image.repart` option provided by
the module [image/repart.nix][]. This module uses `systemd-repart` to build the
images and exposes it's entire interface via the `repartConfig` option.

[image/repart.nix]: https://github.com/NixOS/nixpkgs/blob/master/nixos/modules/image/repart.nix

An example of how to build an image:

```nix
{ config, modulesPath, ... }: {

  imports = [ "${modulesPath}/image/repart.nix" ];

  image.repart = {
    name = "image";
    partitions = {
      "esp" = {
        contents = {
          # ...
        };
        repartConfig = {
          Type = "esp";
          # ...
        };
      };
      "root" = {
        storePaths = [ config.system.build.toplevel ];
        repartConfig = {
          Type = "root";
          Label = "nixos";
          # ...
        };
      };
    };
  };

}
```

## Nix Store Partition {#sec-image-repart-store-partition}

You can define a partition that only contains the Nix store and then mount it
under `/nix/store`. Because the `/nix/store` part of the paths is already
determined by the mount point, you have to set `stripNixStorePrefix = true;` so
that the prefix is stripped from the paths before copying them into the image.

```nix
{
  fileSystems."/nix/store".device = "/dev/disk/by-partlabel/nix-store";

  image.repart.partitions = {
    "store" = {
      storePaths = [ config.system.build.toplevel ];
      stripNixStorePrefix = true;
      repartConfig = {
        Type = "linux-generic";
        Label = "nix-store";
        # ...
      };
    };
  };
}
```

## Appliance Image {#sec-image-repart-appliance}

The `image/repart.nix` module can also be used to build self-contained [software
appliances][].

[software appliances]: https://en.wikipedia.org/wiki/Software_appliance

The generation based update mechanism of NixOS is not suited for appliances.
Updates of appliances are usually either performed by replacing the entire
image with a new one or by updating partitions via an A/B scheme. See the
[Chrome OS update process][chrome-os-update] for an example of how to achieve
this. The appliance image built in the following example does not contain a
`configuration.nix` and thus you will not be able to call `nixos-rebuild` from
this system. Furthermore, it uses a [Unified Kernel Image][unified-kernel-image].

[chrome-os-update]: https://chromium.googlesource.com/aosp/platform/system/update_engine/+/HEAD/README.md
[unified-kernel-image]: https://uapi-group.org/specifications/specs/unified_kernel_image/

```nix
let
  pkgs = import <nixpkgs> { };
  efiArch = pkgs.stdenv.hostPlatform.efiArch;
in
(pkgs.nixos [
  ({ config, lib, pkgs, modulesPath, ... }: {

    imports = [ "${modulesPath}/image/repart.nix" ];

    boot.loader.grub.enable = false;

    fileSystems."/".device = "/dev/disk/by-label/nixos";

    image.repart = {
      name = "image";
      partitions = {
        "esp" = {
          contents = {
            "/EFI/BOOT/BOOT${lib.toUpper efiArch}.EFI".source =
              "${pkgs.systemd}/lib/systemd/boot/efi/systemd-boot${efiArch}.efi";

            "/EFI/Linux/${config.system.boot.loader.ukiFile}".source =
              "${config.system.build.uki}/${config.system.boot.loader.ukiFile}";
          };
          repartConfig = {
            Type = "esp";
            Format = "vfat";
            SizeMinBytes = "96M";
          };
        };
        "root" = {
          storePaths = [ config.system.build.toplevel ];
          repartConfig = {
            Type = "root";
            Format = "ext4";
            Label = "nixos";
            Minimize = "guess";
          };
        };
      };
    };

  })
]).image
```
