{ config, lib, ... }:
{
  meta = {
    maintainers = [ ];
  };

  options = {
    security.lockKernelModules = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = ''
        Disable kernel module loading once the system is fully initialised.
        Module loading is disabled until the next reboot. Problems caused
        by delayed module loading can be fixed by adding the module(s) in
        question to {option}`boot.kernelModules`.
      '';
    };
  };

  config = lib.mkIf config.security.lockKernelModules {
    boot.kernelModules =
      let
        # Pseudo-filesystems that are always built into the kernel (CONFIG_TMPFS=y,
        # CONFIG_PROC_FS=y, etc.) and are never loadable modules.  Passing them to
        # modprobe causes "Failed to find module 'tmpfs'" warnings from
        # systemd-modules-load.service.
        # This list mirrors `specialFSTypes` in tasks/filesystems.nix.
        builtinFS = [
          "proc"
          "sysfs"
          "tmpfs"
          "ramfs"
          "devtmpfs"
          "devpts"
        ];
      in
      lib.filter (m: !builtins.elem m builtinFS) (
        lib.concatMap (
          x:
          lib.optionals (x.device != null) (
            if x.fsType == "vfat" then
              [
                "vfat"
                "nls-cp437"
                "nls-iso8859-1"
              ]
            else
              [ x.fsType ]
          )
        ) config.system.build.fileSystems
      );

    systemd.services.disable-kernel-module-loading = {
      description = "Disable kernel module loading";

      wants = [ "systemd-udevd.service" ];
      wantedBy = [ config.systemd.defaultUnit ];

      after = [
        "firewall.service"
        "systemd-modules-load.service"
        config.systemd.defaultUnit
      ];

      unitConfig.ConditionPathIsReadWrite = "/proc/sys/kernel";

      serviceConfig = {
        Type = "oneshot";
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
