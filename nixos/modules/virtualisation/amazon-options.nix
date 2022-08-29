{ config, lib, pkgs, ... }:
let
  inherit (lib) literalExpression types;
in {
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
          description = lib.mdDoc ''
            Datasets to create under the `tank` and `boot` zpools.

            **NOTE:** This option is used only at image creation time, and
            does not attempt to declaratively create or manage datasets
            on an existing system.
          '';

          default = {};

          type = types.attrsOf (types.submodule {
            options = {
              mount = lib.mkOption {
                description = lib.mdDoc "Where to mount this dataset.";
                type = types.nullOr types.string;
                default = null;
              };

              properties = lib.mkOption {
                description = lib.mdDoc "Properties to set on this dataset.";
                type = types.attrsOf types.string;
                default = {};
              };
            };
          });
        };
      };
      hvm = lib.mkOption {
        default = lib.versionAtLeast config.system.stateVersion "17.03";
        internal = true;
        description = ''
          Whether the EC2 instance is a HVM instance.
        '';
      };
      efi = lib.mkOption {
        default = pkgs.stdenv.hostPlatform.isAarch64;
        defaultText = literalExpression "pkgs.stdenv.hostPlatform.isAarch64";
        internal = true;
        description = ''
          Whether the EC2 instance is using EFI.
        '';
      };
    };
  };

  config = lib.mkIf config.ec2.zfs.enable {
    networking.hostId = lib.mkDefault "00000000";

    fileSystems = let
      mountable = lib.filterAttrs (_: value: ((value.mount or null) != null)) config.ec2.zfs.datasets;
    in lib.mapAttrs'
      (dataset: opts: lib.nameValuePair opts.mount {
        device = dataset;
        fsType = "zfs";
      })
      mountable;
  };
}
