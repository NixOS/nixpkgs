{ config, lib, ... }:

with lib;

{
  meta = {
    maintainers = [ maintainers.joachifm ];
  };

  options = {
    security.lockKernelModules = mkOption {
      type = types.bool;
      default = false;
      description = ''
        Disable kernel module loading once the system is fully initialised.
        Module loading is disabled until the next reboot. Problems caused
        by delayed module loading can be fixed by adding the module(s) in
        question to {option}`boot.kernelModules`.
      '';
    };
  };

  config = mkIf config.security.lockKernelModules {
    boot.kernelModules = concatMap (x:
      optionals (x.device != null) (
        if x.fsType == "vfat"
        then [ "vfat" "nls-cp437" "nls-iso8859-1" ]
        else [ x.fsType ])
      ) config.system.build.fileSystems;

    systemd.services.disable-kernel-module-loading = {
      description = "Disable kernel module loading";

      wants = [ "systemd-udevd.service" ];
      wantedBy = [ config.systemd.defaultUnit ];

      after =
        [ "firewall.service"
          "systemd-modules-load.service"
           config.systemd.defaultUnit
        ];

      unitConfig.ConditionPathIsReadWrite = "/proc/sys/kernel";

      serviceConfig =
        { Type = "oneshot";
          RemainAfterExit = true;
          TimeoutSec = 180;
        };

      script = ''
        ${config.systemd.package}/bin/udevadm settle
        echo -n 1 >/proc/sys/kernel/modules_disabled
      '';
    };
  };
}
