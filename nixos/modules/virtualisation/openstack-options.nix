{ config, lib, pkgs, ... }:
let
  inherit (lib) literalExpression types;
in
{
  options = {
    openstack = {
      zfs = {
        enable = lib.mkOption {
          default = false;
          internal = true;
          description = lib.mdDoc ''
            Whether the OpenStack instance uses a ZFS root.
          '';
        };

        datasets = lib.mkOption {
          description = lib.mdDoc ''
            Datasets to create under the `tank` and `boot` zpools.

            **NOTE:** This option is used only at image creation time, and
            does not attempt to declaratively create or manage datasets
            on an existing system.
          '';

          default = { };

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
                default = { };
              };
            };
          });
        };
      };

      efi = lib.mkOption {
        default = pkgs.stdenv.hostPlatform.isAarch64;
        defaultText = literalExpression "pkgs.stdenv.hostPlatform.isAarch64";
        internal = true;
        description = lib.mdDoc ''
          Whether the instance is using EFI.
        '';
      };
    };
  };

  config = lib.mkIf config.openstack.zfs.enable {
    networking.hostId = lib.mkDefault "00000000";

    fileSystems =
      let
        mountable = lib.filterAttrs (_: value: ((value.mount or null) != null)) config.openstack.zfs.datasets;
      in
      lib.mapAttrs'
        (dataset: opts: lib.nameValuePair opts.mount {
          device = dataset;
          fsType = "zfs";
        })
        mountable;
  };
}
