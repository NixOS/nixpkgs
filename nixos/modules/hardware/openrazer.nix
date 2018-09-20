{ config, pkgs, lib, ... }:

with lib;

let
  cfg = config.hardware.openrazer;

  toPyBoolStr = b: if b then "True" else "False";

  daemonExe = "${cfg.daemonPackage}/bin/openrazer-daemon --config ${daemonConfFile}";

  daemonConfFile = pkgs.writeTextFile {
    name = "razer.conf";
    text = ''
      [General]
      verbose_logging = ${toPyBoolStr cfg.verboseLogging}

      [Startup]
      sync_effects_enabled = ${toPyBoolStr cfg.syncEffectsEnabled}
      devices_off_on_screensaver = ${toPyBoolStr cfg.devicesOffOnScreensaver}
      mouse_battery_notifier = ${toPyBoolStr cfg.mouseBatteryNotifier}

      [Statistics]
      key_statistics = ${toPyBoolStr cfg.keyStatistics}
    '';
  };

  dbusServiceFile = pkgs.writeTextFile rec {
    name = "org.razer.service";
    destination = "/share/dbus-1/services/${name}";
    text = ''
      [D-BUS Service]
      Name=org.razer
      Exec=${daemonExe}
      SystemdService=openrazer-daemon.service
    '';
  };

  drivers = [
    "razerkbd"
    "razermouse"
    "razerfirefly"
    "razerkraken"
    "razermug"
    "razercore"
  ];
in
{
  options = {
    hardware.openrazer = {
      enable = mkEnableOption "OpenRazer drivers and userspace daemon.";

      daemonPackage = mkOption {
        type = types.package;
        default = pkgs.python3Packages.openrazer-daemon;
        defaultText = "pkgs.python3Packages.openrazer-daemon";
        description = ''
          Which package to use as the openrazer daemon.
        '';
      };

      driverPackage = mkOption {
        type = types.package;
        default = config.boot.kernelPackages.openrazer;
        defaultText = "config.boot.kernelPackages.openrazer";
        description = ''
          Which package to use as the openrazer driver.
        '';
      };

      kernelModules = mkOption {
        type = types.listOf (types.enum drivers);
        default = drivers;
        description = ''
          List of openrazer drivers to add as modules to the kernel.
        '';
      };

      verboseLogging = mkOption {
        type = types.bool;
        default = false;
        description = ''
          Whether to enable verbose logging. Logs debug messages.
        '';
      };

      syncEffectsEnabled = mkOption {
        type = types.bool;
        default = true;
        description = ''
          Set the sync effects flag to true so any assignment of
          effects will work across devices.
        '';
      };

      devicesOffOnScreensaver = mkOption {
        type = types.bool;
        default = true;
        description = ''
          Turn off the devices when the systems screensaver kicks in.
        '';
      };

      mouseBatteryNotifier = mkOption {
        type = types.bool;
        default = true;
        description = ''
          Mouse battery notifier.
        '';
      };

      keyStatistics = mkOption {
        type = types.bool;
        default = false;
        description = ''
          Collects number of keypresses per hour per key used to
          generate a heatmap.
        '';
      };
    };
  };

  config = mkIf cfg.enable {
    boot.extraModulePackages = [ cfg.driverPackage ];
    boot.kernelModules = cfg.kernelModules;

    # Makes the man pages available so you can succesfully run
    # > systemctl --user help openrazer-daemon
    environment.systemPackages = [ cfg.daemonPackage.man ];

    services.udev.packages = [ cfg.driverPackage ];
    services.dbus.packages = [ dbusServiceFile ];

    # A user must be a member of the plugdev group in order to start
    # the openrazer-daemon. Therefore we make sure that the plugdev
    # group exists.
    users.groups = { plugdev = {}; };

    systemd.user.services = {
      "openrazer-daemon" = {
        description = "Daemon to manage razer devices in userspace";
        unitConfig.Documentation = "man:openrazer-daemon(8)";
        # Requires a graphical session so the daemon knows when the screensaver
        # starts. See the 'devicesOffOnScreensaver' option.
        wantedBy = [ "graphical-session.target" ];
        partOf = [ "graphical-session.target" ];
        serviceConfig = {
          Type = "dbus";
          BusName = "org.razer";
          ExecStart = "${daemonExe} --foreground";
          Restart = "always";
        };
      };
    };
  };

  meta = {
    maintainers = with lib.maintainers; [ roelvandijk ];
  };
}
