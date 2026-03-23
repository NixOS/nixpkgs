{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.services.tuned;

  moduleFromName = name: lib.getAttrFromPath (lib.splitString "." name) config;
  ppdSettingsFormat = pkgs.formats.ini { };
  profileFormat = pkgs.formats.ini { };
  recommendFormat = pkgs.formats.ini { };
  settingsFormat = pkgs.formats.iniWithGlobalSection { };

  ppdSettingsSubmodule = {
    freeformType = ppdSettingsFormat.type;

    options = {
      main = lib.mkOption {
        type = lib.types.submodule {
          options = {
            default = lib.mkOption {
              type = lib.types.str;
              default = "balanced";
              description = "Default PPD profile.";
              example = "performance";
            };

            battery_detection = lib.mkEnableOption "battery detection" // {
              default = true;
            };
          };
        };
        default = { };
        description = "Core configuration for power-profiles-daemon support.";
      };

      profiles = lib.mkOption {
        type = lib.types.attrsOf lib.types.str;
        default = {
          power-saver = "powersave";
          balanced = "balanced";
          performance = "throughput-performance";
        };
        description = "Map of PPD profiles to native TuneD profiles.";
      };

      battery = lib.mkOption {
        type = lib.types.attrsOf lib.types.str;
        default = {
          balanced = "balanced-battery";
        };
        description = "Map of PPD battery states to TuneD profiles.";
      };
    };
  };
  settingsSubmodule = {
    freeformType = settingsFormat.type;

    options = {
      daemon = lib.mkEnableOption "the use of a daemon for TuneD" // {
        default = true;
      };

      dynamic_tuning = lib.mkEnableOption "dynamic tuning";

      sleep_interval = lib.mkOption {
        type = lib.types.int;
        default = 1;
        description = "Interval in which the TuneD daemon is waken up and checks for events (in seconds).";
      };

      update_interval = lib.mkOption {
        type = lib.types.int;
        default = 10;
        description = "Update interval for dynamic tuning (in seconds).";
      };

      recommend_command = lib.mkEnableOption "recommend functionality" // {
        default = true;
      };

      reapply_sysctl =
        lib.mkEnableOption "the reapplying of global sysctls after TuneD sysctls are applied"
        // {
          default = true;
        };

      default_instance_priority = lib.mkOption {
        type = lib.types.int;
        default = 0;
        description = "Default instance (unit) priority.";
      };

      profile_dirs = lib.mkOption {
        type = lib.types.str;
        default = "/etc/tuned/profiles";
        # Ensure we always have the vendored profiles available
        apply = dirs: "${cfg.package}/lib/tuned/profiles," + dirs;
        description = "Directories to search for profiles, separated by `,` or `;`.";
      };
    };
  };
in
{
  options.services.tuned = {
    enable = lib.mkEnableOption "TuneD";

    package = lib.mkPackageOption pkgs "tuned" { };

    ppdSettings = lib.mkOption {
      type = lib.types.submodule ppdSettingsSubmodule;
      default = { };
      description = ''
        Settings for TuneD's power-profiles-daemon compatibility service.
      '';
    };
    ppdSupport = lib.mkEnableOption "translation of power-profiles-daemon API calls to TuneD" // {
      default = true;
    };
    profiles = lib.mkOption {
      type = lib.types.attrsOf (
        lib.types.submodule {
          freeformType = profileFormat.type;
        }
      );
      default = { };
      description = ''
        Profiles for TuneD.
        See {manpage}`tuned.conf(5)` for details.
      '';
      example = {
        my-cool-profile = {
          main.include = "my-other-cool-profile";

          my_sysctl = {
            type = "sysctl";
            replace = true;

            "net.core.rmem_default" = 262144;
            "net.core.wmem_default" = 262144;
          };
        };
      };
    };
    recommend = lib.mkOption {
      type = recommendFormat.type;
      default = { };
      description = ''
        TuneD rules for `recommend_profile`, written to
        `/etc/tuned/recommend.conf`.

        At startup, the daemon evaluates the file in alphabetical order.
        The first matching entry is applied. Empty profile rules always match.

        If `services.tuned.ppdSupport` is `true`, settings in
        `services.tuned.ppdSettings` take precedence over both the default
        behaviour and `services.tuned.recommend`. For example:
        `services.tuned.ppdSettings.main.default = "performance";` ensures
        the corresponding PPD profile is applied regardless of
        `services.tuned.recommend` setting.

        If `ppdSupport` is `false`, only `services.tuned.recommend` is used;
        if `recommend` is empty, TuneD's default behaviour applies.

        See {manpage}`tuned-main.conf(5)` for more details.
      '';
      example = lib.literalExpression ''
        # Enable `virtual-guest` profile for VM guests
        virtual-guest = {
          virt = ".+";
        };

        # Default to the `desktop` profile for all other systems
        desktop = { };
      '';
    };
    settings = lib.mkOption {
      type = lib.types.submodule settingsSubmodule;
      default = { };
      description = ''
        Configuration for TuneD.
        See {manpage}`tuned-main.conf(5)` for details.
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    assertions = [
      # From `tuned.service`
      {
        assertion = config.security.polkit.enable;
        message = "`services.tuned` requires `security.polkit` to be enabled.";
      }

      {
        assertion = cfg.settings.dynamic_tuning -> cfg.settings.daemon;
        message = "`services.tuned.settings.dynamic_tuning` requires `services.tuned.settings.daemon` to be `true`.";
      }

      {
        assertion = cfg.ppdSupport -> config.services.upower.enable;
        message = "`services.tuned.ppdSupport` requires `services.upower` to be enabled.";
      }
    ]
    # Declare service conflicts, also sourced from `tuned.service`
    ++
      map
        (name: {
          assertion = !(moduleFromName name).enable;
          message = "`services.tuned` conflicts with `${name}`.";
        })
        [
          "hardware.system76.power-daemon"
          "services.auto-cpufreq"
          "services.power-profiles-daemon"
          "services.tlp"
        ];

    environment = {
      etc = lib.mkMerge [
        {
          "tuned/tuned-main.conf".source = settingsFormat.generate "tuned-main.conf" {
            sections = { };
            globalSection = cfg.settings;
          };
        }
        (lib.mkIf cfg.ppdSupport {
          "tuned/ppd.conf".source = ppdSettingsFormat.generate "ppd.conf" cfg.ppdSettings;
        })

        (lib.mkIf (cfg.settings.recommend_command && cfg.recommend != { }) {
          "tuned/recommend.conf".source = recommendFormat.generate "recommend.conf" cfg.recommend;
        })

        (lib.mapAttrs' (
          name: value:
          lib.nameValuePair "tuned/profiles/${name}/tuned.conf" {
            source = profileFormat.generate "tuned.conf" value;
          }
        ) cfg.profiles)
      ];

      systemPackages = [ cfg.package ];
    };

    security.polkit.enable = lib.mkDefault true;

    services = {
      dbus.packages = [ cfg.package ];

      # Many DEs (like GNOME and KDE Plasma) enable PPD by default
      # Let's try to make it easier to transition by only enabling this module
      power-profiles-daemon.enable = false;

      # NOTE: Required by `tuned-ppd` for handling power supply changes
      # (i.e., `services.tuned.ppdSettings.main.battery_detection`)
      # https://github.com/NixOS/nixpkgs/issues/431105
      upower.enable = lib.mkIf cfg.ppdSupport true;
    };

    systemd = {
      packages = [ cfg.package ];

      services = {
        tuned = {
          wantedBy = [ "multi-user.target" ];
        };

        tuned-ppd = lib.mkIf cfg.ppdSupport {
          wantedBy = [ "graphical.target" ];
        };
      };

      tmpfiles = {
        packages = [ cfg.package ];

        # NOTE(@getchoo): `cfg.package` should contain a `tuned.conf` for tmpfiles.d already. Avoid a naming conflict!
        settings.tuned-profiles = {
          # Required for tuned-gui
          "/etc/tuned/profiles".d = { };
        };
      };
    };
  };
}
