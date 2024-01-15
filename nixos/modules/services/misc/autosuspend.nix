{ config, pkgs, lib, ... }:
let
  inherit (lib) mapAttrs' nameValuePair filterAttrs types mkEnableOption
    mdDoc mkPackageOption mkOption literalExpression mkIf flatten
    maintainers attrValues;

  cfg = config.services.autosuspend;

  settingsFormat = pkgs.formats.ini { };

  checks =
    mapAttrs'
      (n: v: nameValuePair "check.${n}" (filterAttrs (_: v: v != null) v))
      cfg.checks;
  wakeups =
    mapAttrs'
      (n: v: nameValuePair "wakeup.${n}" (filterAttrs (_: v: v != null) v))
      cfg.wakeups;

  # Whether the given check is enabled
  hasCheck = class:
    (filterAttrs
      (n: v: v.enabled && (if v.class == null then n else v.class) == class)
      cfg.checks)
    != { };

  # Dependencies needed by specific checks
  dependenciesForChecks = {
    "Smb" = pkgs.samba;
    "XIdleTime" = [ pkgs.xprintidle pkgs.sudo ];
  };

  autosuspend-conf =
    settingsFormat.generate "autosuspend.conf" ({ general = cfg.settings; } // checks // wakeups);

  autosuspend = cfg.package;

  checkType = types.submodule {
    freeformType = settingsFormat.type.nestedTypes.elemType;

    options.enabled = mkEnableOption (mdDoc "this activity check") // { default = true; };

    options.class = mkOption {
      default = null;
      type = with types; nullOr (enum [
        "ActiveCalendarEvent"
        "ActiveConnection"
        "ExternalCommand"
        "JsonPath"
        "Kodi"
        "KodiIdleTime"
        "LastLogActivity"
        "Load"
        "LogindSessionsIdle"
        "Mpd"
        "NetworkBandwidth"
        "Ping"
        "Processes"
        "Smb"
        "Users"
        "XIdleTime"
        "XPath"
      ]);
      description = mdDoc ''
        Name of the class implementing the check.  If this option is not specified, the check's
        name must represent a valid internal check class.
      '';
    };
  };

  wakeupType = types.submodule {
    freeformType = settingsFormat.type.nestedTypes.elemType;

    options.enabled = mkEnableOption (mdDoc "this wake-up check") // { default = true; };

    options.class = mkOption {
      default = null;
      type = with types; nullOr (enum [
        "Calendar"
        "Command"
        "File"
        "Periodic"
        "SystemdTimer"
        "XPath"
        "XPathDelta"
      ]);
      description = mdDoc ''
        Name of the class implementing the check.  If this option is not specified, the check's
        name must represent a valid internal check class.
      '';
    };
  };
in
{
  options = {
    services.autosuspend = {
      enable = mkEnableOption (mdDoc "the autosuspend daemon");

      package = mkPackageOption pkgs "autosuspend" { };

      settings = mkOption {
        type = types.submodule {
          freeformType = settingsFormat.type.nestedTypes.elemType;

          options = {
            # Provide reasonable defaults for these two (required) options
            suspend_cmd = mkOption {
              default = "systemctl suspend";
              type = with types; str;
              description = mdDoc ''
                The command to execute in case the host shall be suspended. This line can contain
                additional command line arguments to the command to execute.
              '';
            };
            wakeup_cmd = mkOption {
              default = ''sh -c 'echo 0 > /sys/class/rtc/rtc0/wakealarm && echo {timestamp:.0f} > /sys/class/rtc/rtc0/wakealarm' '';
              type = with types; str;
              description = mdDoc ''
                The command to execute for scheduling a wake up of the system. The given string is
                processed using Python’s `str.format()` and a format argument called `timestamp`
                encodes the UTC timestamp of the planned wake up time (float). Additionally `iso`
                can be used to acquire the timestamp in ISO 8601 format.
              '';
            };
          };
        };
        default = { };
        example = literalExpression ''
          {
            enable = true;
            interval = 30;
            idle_time = 120;
          }
        '';
        description = mdDoc ''
          Configuration for autosuspend, see
          <https://autosuspend.readthedocs.io/en/latest/configuration_file.html#general-configuration>
          for supported values.
        '';
      };

      checks = mkOption {
        default = { };
        type = with types; attrsOf checkType;
        description = mdDoc ''
          Checks for activity.  For more information, see:
           - <https://autosuspend.readthedocs.io/en/latest/configuration_file.html#activity-check-configuration>
           - <https://autosuspend.readthedocs.io/en/latest/available_checks.html>
        '';
        example = literalExpression ''
          {
            # Basic activity check configuration.
            # The check class name is derived from the section header (Ping in this case).
            # Remember to enable desired checks. They are disabled by default.
            Ping = {
              hosts = "192.168.0.7";
            };

            # This check is disabled.
            Smb.enabled = false;

            # Example for a custom check name.
            # This will use the Users check with the custom name RemoteUsers.
            # Custom names are necessary in case a check class is used multiple times.
            # Custom names can also be used for clarification.
            RemoteUsers = {
              class = "Users";
              name = ".*";
              terminal = ".*";
              host = "[0-9].*";
            };

            # Here the Users activity check is used again with different settings and a different name
            LocalUsers = {
              class = "Users";
              name = ".*";
              terminal = ".*";
              host = "localhost";
            };
          }
        '';
      };

      wakeups = mkOption {
        default = { };
        type = with types; attrsOf wakeupType;
        description = mdDoc ''
          Checks for wake up.  For more information, see:
           - <https://autosuspend.readthedocs.io/en/latest/configuration_file.html#wake-up-check-configuration>
           - <https://autosuspend.readthedocs.io/en/latest/available_wakeups.html>
        '';
        example = literalExpression ''
          {
            # Wake up checks reuse the same configuration mechanism as activity checks.
            Calendar = {
              url = "http://example.org/test.ics";
            };
          }
        '';
      };
    };
  };

  config = mkIf cfg.enable {
    systemd.services.autosuspend = {
      description = "A daemon to suspend your server in case of inactivity";
      documentation = [ "https://autosuspend.readthedocs.io/en/latest/systemd_integration.html" ];
      wantedBy = [ "multi-user.target" ];
      after = [ "network.target" ];
      path = flatten (attrValues (filterAttrs (n: _: hasCheck n) dependenciesForChecks));
      serviceConfig = {
        ExecStart = ''${autosuspend}/bin/autosuspend -l ${autosuspend}/etc/autosuspend-logging.conf -c ${autosuspend-conf} daemon'';
      };
    };

    systemd.services.autosuspend-detect-suspend = {
      description = "Notifies autosuspend about suspension";
      documentation = [ "https://autosuspend.readthedocs.io/en/latest/systemd_integration.html" ];
      wantedBy = [ "sleep.target" ];
      after = [ "sleep.target" ];
      serviceConfig = {
        ExecStart = ''${autosuspend}/bin/autosuspend -l ${autosuspend}/etc/autosuspend-logging.conf -c ${autosuspend-conf} presuspend'';
      };
    };
  };

  meta = {
    maintainers = with maintainers; [ xlambein ];
  };
}
