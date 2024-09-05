{ config, lib, ... }:

let
  cfg = config.boot.initrd.systemd.dmVerity;
in
{
  options = {
    boot.initrd.systemd.dmVerity = {
      enable = lib.mkEnableOption "dm-verity" // {
        description = ''
          Mount verity-protected block devices in the initrd.

          Enabling this option allows to use `systemd-veritysetup` and
          `systemd-veritysetup-generator` in the initrd.
        '';
      };
    };
  };

  config = lib.mkIf cfg.enable {
    assertions = [
      {
        assertion = cfg.enable -> config.boot.initrd.systemd.enable;
        message = ''
          'boot.initrd.systemd.dmVerity.enable' requires 'boot.initrd.systemd.enable' to be enabled.
        '';
      }
    ];

    boot.initrd = {
      availableKernelModules = [
        # For documentation, see https://docs.kernel.org/admin-guide/device-mapper/dm-init.html
        "dm_mod"
        # For documentation, see:
        # - https://docs.kernel.org/admin-guide/device-mapper/verity.html
        # - https://gitlab.com/cryptsetup/cryptsetup/-/wikis/DMVerity
        "dm_verity"
      ];

      # dm-verity needs additional udev rules from LVM to work.
      services.lvm.enable = true;

      # The additional targets and store paths allow users to integrate verity-protected devices
      # through the systemd tooling.
      systemd = {
        additionalUpstreamUnits = [
          # https://github.com/systemd/systemd/blob/main/units/veritysetup-pre.target
          "veritysetup-pre.target"
          # https://github.com/systemd/systemd/blob/main/units/veritysetup.target
          "veritysetup.target"
          # https://github.com/systemd/systemd/blob/main/units/remote-veritysetup.target
          "remote-veritysetup.target"
        ];

        storePaths = [
          # These are the two binaries mentioned in https://github.com/systemd/systemd/blob/main/src/veritysetup/meson.build; there are no others.
          "${config.boot.initrd.systemd.package}/lib/systemd/systemd-veritysetup"
          "${config.boot.initrd.systemd.package}/lib/systemd/system-generators/systemd-veritysetup-generator"
        ];
      };
    };
  };

  meta.maintainers = [ lib.maintainers.msanft ];
}
