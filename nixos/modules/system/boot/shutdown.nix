{ config, lib, pkgs, ... }:

with lib;

{

  # This unit saves the value of the system clock to the hardware
  # clock on shutdown.
  systemd.services.save-hwclock =
    { description = "Save Hardware Clock";

      wantedBy = [ "shutdown.target" ];

      unitConfig = {
        DefaultDependencies = false;
        ConditionPathExists = "/dev/rtc";
      };

      serviceConfig = {
        Type = "oneshot";
        ExecStart = "${pkgs.utillinux}/sbin/hwclock --systohc ${if config.time.hardwareClockInLocalTime then "--localtime" else "--utc"}";
      };
    };

  boot.kernel.sysctl."kernel.poweroff_cmd" = "${config.systemd.package}/sbin/poweroff";

}
