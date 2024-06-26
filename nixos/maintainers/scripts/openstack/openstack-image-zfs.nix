# nix-build '<nixpkgs/nixos>' -A config.system.build.openstackImage --arg configuration "{ imports = [ ./nixos/maintainers/scripts/openstack/openstack-image.nix ]; }"

{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib) mkOption types;
  copyChannel = true;
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

    ramMB = mkOption {
      type = types.int;
      default = 1024;
      description = "RAM allocation for build VM";
    };

    sizeMB = mkOption {
      type = types.int;
      default = 8192;
      description = "The size in MB of the image";
    };

    format = mkOption {
      type = types.enum [
        "raw"
        "qcow2"
      ];
      default = "qcow2";
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

    system.build.openstackImage = import ../../../lib/make-single-disk-zfs-image.nix {
      inherit lib config;
      inherit (cfg) contents format name;
      pkgs = import ../../../.. { inherit (pkgs) system; }; # ensure we use the regular qemu-kvm package

      configFile = pkgs.writeText "configuration.nix" ''
        { modulesPath, ... }: {
          imports = [ "''${modulesPath}/virtualisation/openstack-config.nix" ];
          openstack.zfs.enable = true;
        }
      '';

      includeChannel = copyChannel;

      bootSize = 1000;
      memSize = cfg.ramMB;
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
         mv "$rootDiskImage" "$rootDisk"

         mkdir -p $out/nix-support
         echo "file ${cfg.format} $rootDisk" >> $out/nix-support/hydra-build-products

        ${pkgs.jq}/bin/jq -n \
          --arg system_label ${lib.escapeShellArg config.system.nixos.label} \
          --arg system ${lib.escapeShellArg pkgs.stdenv.hostPlatform.system} \
          --arg root_logical_bytes "$(${pkgs.qemu_kvm}/bin/qemu-img info --output json "$rootDisk" | ${pkgs.jq}/bin/jq '."virtual-size"')" \
          --arg boot_mode "${imageBootMode}" \
          --arg root "$rootDisk" \
         '{}
           | .label = $system_label
           | .boot_mode = $boot_mode
           | .system = $system
           | .disks.root.logical_bytes = $root_logical_bytes
           | .disks.root.file = $root
           ' > $out/nix-support/image-info.json
      '';
    };
  };
}
