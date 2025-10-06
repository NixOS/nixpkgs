{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.boot.crashDump;
in
{
  meta.maintainers = with lib.maintainers; [ Scrumplex ];

  options.boot.crashDump = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = ''
        If enabled, NixOS will set up a kernel that will
        boot on crash, and leave the user in systemd rescue
        to be able to save the crashed kernel dump at
        /proc/vmcore.
        It also activates the NMI watchdog.
      '';
    };

    automatic = lib.mkEnableOption "automatic dumping of kernel logs after a panic";

    reservedMemory = lib.mkOption {
      default = "256M";
      type = lib.types.str;
      description = ''
        The amount of memory reserved for the crashdump kernel.
        If you choose a too high value, dmesg will mention
        "crashkernel reservation failed".
      '';
    };

    kernelParams = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [ ];
      description = ''
        Parameters that will be passed to the kernel kexec-ed on crash.
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    assertions = [
      {
        assertion = cfg.automatic -> config.boot.initrd.systemd.enable;
        message = "Automatic crash dumps are only supported on systemd-based initrd. Enable the option boot.initrd.systemd.enable";
      }
    ];

    boot = {
      kernel.sysctl = {
        "kernel.panic" = -1;
        "kernel.panic_on_oops" = 1;
        "kernel.hardlockup_panic" = 1;
        "kernel.softlockup_panic" = 1;
      };

      initrd.systemd.services."dump-dmesg" = lib.mkIf cfg.automatic {
        script = ''
          if [ ! -f /proc/vmcore ]; then
            echo "No /proc/vmcore. Baling out" >&2
            reboot -f
            exit 0
          fi

          ${lib.getExe pkgs.makedumpfile} --dump-dmesg /proc/vmcore /sysroot/dmesg.txt
          reboot -f
        '';
        unitConfig = {
          RequiresMountsFor = "/sysroot";
        };
        serviceConfig = {
          Type = "oneshot";
          RemainAfterExit = true;
        };
      };

      initrd.systemd = {
        storePaths = [
          (lib.getExe pkgs.makedumpfile)
        ];
      };

      kernelParams = [
        "crashkernel=${cfg.reservedMemory}"
        "nmi_watchdog=panic"
      ];
    };

    systemd.services."load-crashkernel" = {
      script =
        let
          kernelParams = [
            "init=$(readlink -f /run/current-system/init)"
            "irqpoll"
            "maxcpus=1"
            "reset_devices"
          ]
          ++ lib.optionals cfg.automatic [
            "rd.systemd.unit=dump-dmesg.service"
          ]
          ++ cfg.kernelParams;
        in
        ''
          ${lib.getExe pkgs.kexec-tools} -p /run/current-system/kernel \
            --initrd=/run/current-system/initrd \
            --reset-vga --console-vga \
            --command-line="${lib.concatStringsSep " " kernelParams}" # TODO: deal with escaping strings
        '';
      before = [
        "shutdown.target"
      ];
      conflicts = [ "shutdown.target" ];
      requiredBy = [ "sysinit.target" ];
      serviceConfig = {
        Type = "oneshot";
        RemainAfterExit = true;
      };
    };
  };
}
