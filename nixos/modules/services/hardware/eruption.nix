{
  pkgs,
  lib,
  config,
  ...
}:
let
  cfg = config.services.hardware.eruption;
in
{
  options.services.hardware.eruption = {
    enable = lib.mkEnableOption "Realtime RGB LED Driver for Linux";

    package = lib.mkPackageOption pkgs "eruption" { };

    enableExperimentalFeatures = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Set this to true, to enable feature-gated functionality. May expose serious bugs";
    };
    driverMaturityLevel = lib.mkOption {
      type = lib.types.enum [
        "stable"
        "testing"
        "experimental"
      ];
      default = "testing";
      description = "only allows drivers with the respective code maturity level to bind";
    };
    keyboardVariant = lib.mkOption {
      type = lib.types.enum [
        "ISO"
        "ANSI"
      ];
      default = "ISO";
      description = "Switch between sub-variants of your device. (Only partially supported)";
    };
    enableMouse = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Enable support for mouse events. Will open the evdev device in shared mode";
    };
    grabMouse = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Enable support for mouse event injection. Will open the evdev device in exclusive mode. Disable this feature if you want to use 3rd party mouse driver software";
    };
    afkProfile = lib.mkOption {
      type = lib.types.str;
      default = "rainbow-wave.profile";
      description = "The profile to load when the user is AFK (Away from Keyboard)";
    };
    afkTimeoutSecs = lib.mkOption {
      type = lib.types.int;
      default = 0;
      description = "Time that has to pass without any input events, until AFK mode is activated. Specify 0 seconds to disable the AFK mode feature";
    };
    profileFadeMilliseconds = lib.mkOption {
      type = lib.types.int;
      default = 1333;
      description = "Fade duration when switching profiles";
    };

    profileDirs = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [ ];
      description = "List of paths to directories containing profile files";
    };
    includeStandardProfiles = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Set this to false to exclude the profiles shipped with eruption itself from profileDirs";
    };

    scriptDirs = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [ ];
      description = "List of paths to directories containing script files";
    };
    includeStandardScripts = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Set this to false to exclude the scripts shipped with eruption itself from scriptDirs";
    };
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
    environment.variables = {
      GSETTINGS_SCHEMA_DIR = "${cfg.package}/usr/share/eruption-gui-gtk3/schemas:${pkgs.gtk3}/share/gsettings-schemas/gtk+3-${pkgs.gtk3.version}/glib-2.0/schemas";
    };

    services.dbus.enable = true;
    services.dbus.packages = [ cfg.package ];

    services.udev.enable = true;
    services.udev.packages = [ cfg.package ];

    security.polkit.enable = true;

    systemd.services = {
      eruption = {
        description = "Realtime RGB LED Driver for Linux";
        documentation = [
          "man:eruption(8)"
          "man:eruption.conf(5)"
          "man:eruptionctl(1)"
          "man:eruption-netfx(1)"
        ];
        wants = [ "basic.target" ];
        wantedBy = [ "basic.target" ];
        startLimitIntervalSec = 300;
        startLimitBurst = 3;
        environment = {
          "RUST_LOG" = "warn";
        };

        serviceConfig = {
          RuntimeDirectory = "eruption";
          PIDFile = /run/eruption/eruption.pid;
          ExecStart = "${cfg.package}/bin/eruption -c /etc/eruption/eruption.conf";
          TimeoutStopSec = 10;
          Type = "exec";
          Restart = "always";
          WatchdogSec = 8;
          WatchdogSignal = "SIGKILL";
          CPUSchedulingPolicy = "rr";
          CPUSchedulingPriority = 20;
        };

        enable = true;
      };

      "eruption-install-files" = {
        description = "Install all files for Eruption";
        after = [ "network.target" ];
        before = [ "eruption.service" ];
        wantedBy = [ "multi-user.target" ];

        serviceConfig = {
          Type = "oneshot";
          RemainAfterExit = true;
          ExecStop = "${pkgs.coreutils}/bin/rm -r /usr/share/eruption /usr/share/eruption-gui-gtk3 /var/lib/eruption/profiles";
          TimoutStopSec = 10;
        };
        script = ''
          for abs_path in $(find "${cfg.package}/usr/share/eruption/scripts" -type f) $(find "${cfg.package}/var/lib/eruption/profiles" -type f) "${cfg.package}/usr/share/eruption-gui-gtk3/schemas/gschemas.compiled"; do
              rel_path=$(realpath --relative-to="${cfg.package}" "$abs_path")
              mkdir -p $(dirname "/$rel_path")
              ln -sf "$abs_path" "/$rel_path"
          done
        '';

        enable = true;
      };
    };

    systemd.user.services = {
      "eruption-audio-proxy" = {
        description = "Audio proxy daemon for Eruption";
        documentation = [
          "man:eruption-audio-proxy(1)"
          "man:audio-proxy.conf(5)"
          "man:eruptionctl(1)"
        ];
        requires = [ "sound.target" ];
        partOf = [ "graphical-session.target" ];
        bindsTo = [ "graphical-session.target" ];
        wantedBy = [ "graphical-session.target" ];
        startLimitIntervalSec = 60;
        startLimitBurst = 3;
        environment = {
          "RUST_LOG" = "warn";
          "PULSE_LATENCY_MSEC" = "30";
        };

        serviceConfig = {
          ExecStart = "${cfg.package}/bin/eruption-audio-proxy -c ${cfg.package}/etc/eruption/audio-proxy.conf daemon";
          PIDFile = /run/eruption-audio-proxy.pid;
          Type = "exec";
          Restart = "always";
          RestartSec = 1;
        };

        enable = true;
      };

      "eruption-fx-proxy" = {
        description = "Effects proxy daemon for Eruption";
        documentation = [
          "man:eruption-fx-proxy(1)"
          "man:fx-proxy.conf(5)"
          "man:eruptionctl(1)"
        ];
        wants = [ "graphical-session.target" ];
        bindsTo = [ "graphical-session.target" ];
        wantedBy = [ "graphical-session.target" ];
        after = [ "graphical-session.target" ];
        startLimitIntervalSec = 60;
        startLimitBurst = 3;
        environment = {
          "RUST_LOG" = "warn";
        };

        serviceConfig = {
          ExecStart = "${cfg.package}/bin/eruption-fx-proxy -c ${cfg.package}/etc/eruption/fx-proxy.conf daemon";
          PIDFile = /run/eruption-audio-proxy.pid;
          Type = "exec";
          Restart = "always";
          RestartSec = 1;
        };

        enable = true;
      };

      "eruption-process-monitor" = {
        description = "Process Monitoring and Introspection for Eruption";
        documentation = [
          "man:eruption-process-monitor(1)"
          "man:process-monitor.conf(5)"
          "man:eruptionctl(1)"
        ];
        partOf = [ "graphical-session.target" ];
        bindsTo = [ "graphical-session.target" ];
        wantedBy = [ "graphical-session.target" ];
        startLimitIntervalSec = 60;
        startLimitBurst = 3;
        environment = {
          "RUST_LOG" = "warn";
        };

        serviceConfig = {
          PassEnvironment = "WAYLAND_DISPLAY XDG_SESSION_TYPE XDG_CURRENT_DESKTOP DISPLAY XAUTHORITY";
          ExecStart = "${cfg.package}/bin/eruption-process-monitor -c ${cfg.package}/etc/eruption/process-monitor.conf daemon";
          PIDFile = /run/eruption-process-monitor.pid;
          Type = "exec";
          Restart = "always";
          RestartSec = 1;
        };

        enable = true;
      };
    };

    environment.etc =
      let
        standardProfiles = lib.optionals cfg.includeStandardProfiles [ "/var/lib/eruption/profiles/" ];
        standardScripts = lib.optionals cfg.includeStandardScripts [ "/usr/share/eruption/scripts/" ];
        profileDirs = "\"" + (lib.concatStringsSep "\", \"" (standardProfiles ++ cfg.profileDirs)) + "\"";
        scriptDirs = "\"" + (lib.concatStringsSep "\", \"" (standardScripts ++ cfg.scriptDirs)) + "\"";
      in
      {
        "eruption/eruption.conf".text = ''
          # Eruption - Realtime RGB LED Driver for Linux
          # Main configuration file

          # This file has been generated by the NixOS Confiuguration
          # Edit your confguration.nix to edit this file

          [global]
          enable_experimental_features = ${lib.boolToString cfg.enableExperimentalFeatures}
          driver_maturity_level = "${cfg.driverMaturityLevel}"

          profile_dirs = [ ${profileDirs} ]
          script_dirs = [ ${scriptDirs} ]

          keyboard_variant = "${cfg.keyboardVariant}"

          enable_mouse = ${lib.boolToString cfg.enableMouse}
          grab_mouse = ${lib.boolToString cfg.grabMouse}

          afk_profile = "${cfg.afkProfile}"
          afk_timeout_secs = ${toString cfg.afkTimeoutSecs}

          profile_fade_milliseconds = ${toString cfg.profileFadeMilliseconds}
        '';
        "eruption/profile.d/eruption.sh".source = "${cfg.package}/etc/profile.d/eruption.sh";
      };
  };

  meta.maintainers = with lib.maintainers; [ puckla ];
}
