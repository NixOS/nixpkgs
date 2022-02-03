# nix-build '<nixpkgs/nixos>' -A config.system.build.openstackImage --arg configuration "{ imports = [ ./nixos/maintainers/scripts/openstack/openstack-image.nix ]; }"

{ config, lib, pkgs, ... }:
let
  inherit (lib) mkOption types;
  copyChannel = false;
  cfg = config.openstackImage;
  imageBootMode = if config.openstack.efi then "uefi" else "legacy-bios";
in
{
  imports = [
    ../../../modules/virtualisation/openstack-config.nix
  ] ++ (lib.optional copyChannel ../../../modules/installer/cd-dvd/channel.nix);


  options.openstackImage = {
    name = mkOption {
      type = types.str;
      description = "The name of the generated derivation";
      default = "nixos-openstack-image-${config.system.nixos.label}-${pkgs.stdenv.hostPlatform.system}";
    };

    sizeMB = mkOption {
      type = types.int;
      default = 8192;
      description = "The size in MB of the image";
    };

    format = mkOption {
      type = types.enum [ "raw" "qcow2" "vpc" ];
      default = "vpc";
      description = "The image format to output";
    };
  };

  config = {
    documentation.enable = copyChannel;
    openstack = {
      efi = true;
      zfs = {
        enable = true;
        datasets = {
          "tank/system/root".mount = "/";
          "tank/system/var".mount = "/var";
          "tank/local/nix".mount = "/nix";
          "tank/user/home".mount = "/home";
        };
      };
    };

    system.build.openstackImage' = import ../../../lib/make-disk-image.nix {
      inherit lib config copyChannel;
      additionalSpace = "1024M";
      pkgs = import ../../../.. { inherit (pkgs) system; }; # ensure we use the regular qemu-kvm package
      format = "qcow2";

    };

    system.build.openstackImage = import ../../../lib/make-zfs-image.nix {
      inherit lib config;
      inherit (cfg) contents format name;
      pkgs = import ../../../.. { inherit (pkgs) system; }; # ensure we use the regular qemu-kvm package

      configFile = pkgs.writeText "configuration.nix"
        ''
          {
            imports = [ <nixpkgs/nixos/modules/virtualisation/openstack-config.nix> ];
          }
        '';

      includeChannel = copyChannel;

      bootSize = 1000;

      rootSize = cfg.sizeMB;
      rootPoolProperties = {
        ashift = 12;
        autoexpand = "on";
      };

      datasets = config.openstack.zfs.datasets;

      postVM = ''
         extension=''${rootDiskImage##*.}
         friendlyName=$out/${cfg.name}
         rootDisk="$friendlyName.root.$extension"
         bootDisk="$friendlyName.boot.$extension"
         mv "$rootDiskImage" "$rootDisk"
         mv "$bootDiskImage" "$bootDisk"

         mkdir -p $out/nix-support
         echo "file ${cfg.format} $bootDisk" >> $out/nix-support/hydra-build-products
         echo "file ${cfg.format} $rootDisk" >> $out/nix-support/hydra-build-products

        ${pkgs.jq}/bin/jq -n \
          --arg system_label ${lib.escapeShellArg config.system.nixos.label} \
          --arg system ${lib.escapeShellArg pkgs.stdenv.hostPlatform.system} \
          --arg root_logical_bytes "$(${pkgs.qemu}/bin/qemu-img info --output json "$rootDisk" | ${pkgs.jq}/bin/jq '."virtual-size"')" \
          --arg boot_logical_bytes "$(${pkgs.qemu}/bin/qemu-img info --output json "$bootDisk" | ${pkgs.jq}/bin/jq '."virtual-size"')" \
          --arg boot_mode "${imageBootMode}" \
          --arg root "$rootDisk" \
          --arg boot "$bootDisk" \
         '{}
           | .label = $system_label
           | .boot_mode = $boot_mode
           | .system = $system
           | .disks.boot.logical_bytes = $boot_logical_bytes
           | .disks.boot.file = $boot
           | .disks.root.logical_bytes = $root_logical_bytes
           | .disks.root.file = $root
           ' > $out/nix-support/image-info.json
      '';
    };
  };
}
