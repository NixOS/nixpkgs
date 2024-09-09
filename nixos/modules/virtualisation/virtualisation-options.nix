# This modules declares shared options for virtual machines,
# containers and anything else in `virtualisation`.
#
# This is useful to declare e.g. defaults for
# `virtualisation.diskSize` once, while building multiple
# different image formats of a NixOS configuration.
#
# Additional options can be migrated over time from
# `modules/virtualisation/qemu-vm.nix` and others.
# Please keep defaults and descriptions here generic
# and independent of i.e. hypervisor-specific notes
# and defaults where.
# Those can be added in the consuming modules where needed.
# needed.
let
  _file = ./virtualisation-options.nix;
  key = _file;
in
{
  diskSize =
    { lib, config, ... }:
    let
      t = lib.types;
    in
    {
      inherit _file key;

      options = {
        virtualisation.diskSizeAutoSupported = lib.mkOption {
          type = t.bool;
          default = true;
          description = ''
            Whether the current image builder or vm runner supports `virtualisation.diskSize = "auto".`
          '';
          internal = true;
        };

        virtualisation.diskSize = lib.mkOption {
          type = t.either (t.enum [ "auto" ]) t.ints.positive;
          default = "auto";
          description = ''
            The disk size in megabytes of the virtual machine.
          '';
        };
      };

      config =
        let
          inherit (config.virtualisation) diskSize diskSizeAutoSupported;
        in
        {
          assertions = [
            {
              assertion = diskSize != "auto" || diskSizeAutoSupported;
              message = "Setting virtualisation.diskSize to `auto` is not supported by the current image build or vm runner; use an explicit size.";
            }
          ];
        };
    };
}
