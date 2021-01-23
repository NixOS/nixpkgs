{ config, lib, pkgs, ... }:

with lib;

let
  crashdump = config.boot.crashDump;

  kernelParams = concatStringsSep " " crashdump.kernelParams;

in
###### interface
{
  options = {
    boot = {
      crashDump = {
        enable = mkOption {
          type = types.bool;
          default = false;
          description = ''
            If enabled, NixOS will set up a kernel that will
            boot on crash, and leave the user in systemd rescue
            to be able to save the crashed kernel dump at
            /proc/vmcore.
            It also activates the NMI watchdog.
          '';
        };
        reservedMemory = mkOption {
          default = "128M";
          type = types.str;
          description = ''
            The amount of memory reserved for the crashdump kernel.
            If you choose a too high value, dmesg will mention
            "crashkernel reservation failed".
          '';
        };
        kernelParams = mkOption {
          type = types.listOf types.str;
          default = [ "1" "boot.shell_on_fail" ];
          description = ''
            Parameters that will be passed to the kernel kexec-ed on crash.
          '';
        };
      };
    };
  };

###### implementation

  config = mkIf crashdump.enable {
    boot = {
      postBootCommands = ''
        echo "loading crashdump kernel...";
        ${pkgs.kexectools}/sbin/kexec -p /run/current-system/kernel \
        --initrd=/run/current-system/initrd \
        --reset-vga --console-vga \
        --command-line="systemConfig=$(readlink -f /run/current-system) init=$(readlink -f /run/current-system/init) irqpoll maxcpus=1 reset_devices ${kernelParams}"
      '';
      kernelParams = [
       "crashkernel=${crashdump.reservedMemory}"
       "nmi_watchdog=panic"
       "softlockup_panic=1"
      ];
      kernelPatches = [ {
        name = "crashdump-config";
        patch = null;
        extraConfig = ''
                CRASH_DUMP y
                DEBUG_INFO y
                PROC_VMCORE y
                LOCKUP_DETECTOR y
                HARDLOCKUP_DETECTOR y
              '';
        } ];
    };
  };
}
