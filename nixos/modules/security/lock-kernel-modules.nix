{ config, lib, ... }:

with lib;

{
  options = {
    security.lockKernelModules = mkOption {
      type = types.bool;
      default = false;
      description = ''
        Disable kernel module loading once the system is fully initialised.
        Module loading is disabled until the next reboot.  Problems caused
        by delayed module loading can be fixed by adding the module(s) in
        question to <option>boot.kernelModules</option>.
      '';
    };

    security.enforceModuleSignature = mkOption {
      type = types.bool;
      default = false;
      description = ''
        Refuse to load any non signed kernel module.
        Warning: currently nixpkgs signs upstream kernel modules only. This
        means that this options will prevent you from loading any third party kernel
        module (which is required by zfs or virtualbox for example).
      '';
    };
  };

  config = (mkIf config.security.lockKernelModules {
    boot.kernelModules = concatMap (x:
      if x.device != null
        then
          if x.fsType == "vfat"
            then [ "vfat" "nls-cp437" "nls-iso8859-1" ]
            else [ x.fsType ]
        else []) config.system.build.fileSystems;

    systemd.services.disable-kernel-module-loading = rec {
      description = "Disable kernel module loading";

      wantedBy = [ config.systemd.defaultUnit ];

      after = [ "systemd-udev-settle.service" "firewall.service" "systemd-modules-load.service" ] ++ wantedBy;

      unitConfig.ConditionPathIsReadWrite = "/proc/sys/kernel";

      serviceConfig = {
        Type = "oneshot";
        RemainAfterExit = true;
        ExecStart = "/bin/sh -c 'echo -n 1 >/proc/sys/kernel/modules_disabled'";
      };
    };
  }) // (mkIf config.security.enforceModuleSignature {
    boot.kernelParams = ["module.sig_enforce"];
  });
}
