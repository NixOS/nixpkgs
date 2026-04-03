{
  config,
  lib,
  options,
  ...
}:

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

  config = lib.mkIf cfg.enable (
    lib.mkMerge [
      {
        assertions = [
          {
            assertion = config.boot.initrd.systemd.enable;
            message = ''
              'boot.initrd.systemd.dmVerity.enable' requires 'boot.initrd.systemd.enable' to be enabled.
            '';
          }
        ];

        boot.initrd = {
          availableKernelModules = [
            "dm_mod"
            "dm_verity"
          ];

          # The additional targets and store paths allow users to integrate verity-protected devices
          # through the systemd tooling.
          systemd = {
            additionalUpstreamUnits = [
              "veritysetup-pre.target"
              "veritysetup.target"
              "remote-veritysetup.target"
            ];

            storePaths = [
              "${config.boot.initrd.systemd.package}/lib/systemd/systemd-veritysetup"
              "${config.boot.initrd.systemd.package}/lib/systemd/system-generators/systemd-veritysetup-generator"
            ];
          };
        };
      }

      # dm-verity needs additional udev rules from LVM to work.
      (lib.optionalAttrs (options ? boot.initrd.services.lvm) {
        boot.initrd.services.lvm.enable = true;
      })
    ]
  );

  meta.maintainers = with lib.maintainers; [
    msanft
    nikstur
    willibutz
  ];
}
