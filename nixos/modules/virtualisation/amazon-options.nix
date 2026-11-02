{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib) literalExpression types;
in
{
  options = {
    ec2 = {
      zfs = {
        enable = lib.mkOption {
          default = false;
          internal = true;
          description = ''
            Whether the EC2 instance uses a ZFS root.
          '';
        };

        datasets = lib.mkOption {
          description = ''
            Datasets to create under the `tank` and `boot` zpools.

            **NOTE:** This option is used only at image creation time, and
            does not attempt to declaratively create or manage datasets
            on an existing system.
          '';

          default = { };

          type = types.attrsOf (
            types.submodule {
              options = {
                mount = lib.mkOption {
                  description = "Where to mount this dataset.";
                  type = types.nullOr types.str;
                  default = null;
                };

                properties = lib.mkOption {
                  description = "Properties to set on this dataset.";
                  type = types.attrsOf types.str;
                  default = { };
                };
              };
            }
          );
        };
      };
      efi = lib.mkOption {
        default = pkgs.stdenv.hostPlatform.isAarch64;
        defaultText = literalExpression "pkgs.stdenv.hostPlatform.isAarch64";
        internal = true;
        description = ''
          Whether the EC2 instance is using EFI.
        '';
      };
      bootMode = lib.mkOption {
        type = types.enum [
          "legacy-bios"
          "uefi"
          "uefi-preferred"
        ];
        default = if config.ec2.efi then "uefi" else "legacy-bios";
        defaultText = literalExpression ''if config.ec2.efi then "uefi" else "legacy-bios"'';
        description = ''
          The boot mode the instance uses on EC2. `uefi-preferred` installs GRUB
          for both UEFI and legacy BIOS, so the instance boots on every instance
          type.
        '';
      };
      hvm = lib.mkOption {
        description = "Unused legacy option. While support for non-hvm has been dropped, we keep this option around so that NixOps remains compatible with a somewhat recent `nixpkgs` and machines with an old `stateVersion`.";
        internal = true;
        default = true;
        readOnly = true;
      };
    };
  };

  config = lib.mkIf config.ec2.zfs.enable {
    networking.hostId = lib.mkDefault "00000000";

    fileSystems =
      let
        mountable = lib.filterAttrs (_: value: ((value.mount or null) != null)) config.ec2.zfs.datasets;
      in
      lib.mapAttrs' (
        dataset: opts:
        lib.nameValuePair opts.mount {
          device = dataset;
          fsType = "zfs";
        }
      ) mountable;
  };
}
