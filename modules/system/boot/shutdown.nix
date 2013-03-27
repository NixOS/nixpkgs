{ config, pkgs, ... }:

with pkgs.lib;

{

  # This unit saves the value of the system clock to the hardware
  # clock on shutdown.
  systemd.units."save-hwclock.service" =
    { wantedBy = [ "shutdown.target" ];

      text =
        ''
          [Unit]
          Description=Save Hardware Clock
          DefaultDependencies=no
          Before=shutdown.target

          [Service]
          Type=oneshot
          ExecStart=${pkgs.utillinux}/sbin/hwclock --systohc ${if config.time.hardwareClockInLocalTime then "--localtime" else "--utc"}
        '';
    };

  boot.kernel.sysctl."kernel.poweroff_cmd" = "${config.systemd.package}/sbin/poweroff";

}
