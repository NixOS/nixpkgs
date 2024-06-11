{ config, pkgs, lib, ... }:

with lib;

let
  cfg = config.hardware.openrazer;
  kernelPackages = config.boot.kernelPackages;

  toPyBoolStr = b: if b then "True" else "False";

  daemonExe = "${pkgs.openrazer-daemon}/bin/openrazer-daemon --config ${daemonConfFile}";

  daemonConfFile = pkgs.writeTextFile {
    name = "razer.conf";
    text = ''
      [General]
      verbose_logging = ${toPyBoolStr cfg.verboseLogging}

      [Startup]
      sync_effects_enabled = ${toPyBoolStr cfg.syncEffectsEnabled}
      devices_off_on_screensaver = ${toPyBoolStr cfg.devicesOffOnScreensaver}
      battery_notifier = ${toPyBoolStr cfg.batteryNotifier.enable}
      battery_notifier_freq = ${builtins.toString cfg.batteryNotifier.frequency}
      battery_notifier_percent = ${builtins.toString cfg.batteryNotifier.percentage}

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
      enable = mkEnableOption ''
        OpenRazer drivers and userspace daemon
      '';

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

      batteryNotifier = mkOption {
        description = ''
          Settings for device battery notifications.
        '';
        default = {};
        type = types.submodule {
          options = {
            enable = mkOption {
              type = types.bool;
              default = true;
              description = ''
                Mouse battery notifier.
              '';
            };
            frequency = mkOption {
              type = types.int;
              default = 600;
              description = ''
                How often battery notifications should be shown (in seconds).
                A value of 0 disables notifications.
              '';
            };

            percentage = mkOption {
              type = types.int;
              default = 33;
              description = ''
                At what battery percentage the device should reach before
                sending notifications.
              '';
            };
          };
        };
      };

      keyStatistics = mkOption {
        type = types.bool;
        default = false;
        description = ''
          Collects number of keypresses per hour per key used to
          generate a heatmap.
        '';
      };

      users = mkOption {
        type = with types; listOf str;
        default = [];
        description = ''
          Usernames to be added to the "openrazer" group, so that they
          can start and interact with the OpenRazer userspace daemon.
        '';
      };
    };
  };

  imports = [
    (mkRenamedOptionModule [ "hardware" "openrazer" "mouseBatteryNotifier" ] [ "hardware" "openrazer" "batteryNotifier" "enable" ])
  ];

  config = mkIf cfg.enable {
    boot.extraModulePackages = [ kernelPackages.openrazer ];
    boot.kernelModules = drivers;

    # Makes the man pages available so you can successfully run
    # > systemctl --user help openrazer-daemon
    environment.systemPackages = [ pkgs.python3Packages.openrazer-daemon.man ];

    services.udev.packages = [ kernelPackages.openrazer ];
    services.dbus.packages = [ dbusServiceFile ];

    # A user must be a member of the openrazer group in order to start
    # the openrazer-daemon. Therefore we make sure that the group
    # exists.
    users.groups.openrazer = {
      members = cfg.users;
    };

    systemd.user.services.openrazer-daemon = {
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

  meta = {
    maintainers = with lib.maintainers; [ roelvandijk ];
  };
}
