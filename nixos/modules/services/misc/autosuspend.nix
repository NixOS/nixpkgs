{
  config,
  pkgs,
  lib,
  ...
}:
let
  cfg = config.services.autosuspend;

  settingsFormat = pkgs.formats.ini { };

  checks = lib.mapAttrs' (n: v: lib.nameValuePair "check.${n}" (lib.filterAttrs (_: v: v != null) v)) cfg.checks;
  wakeups = lib.mapAttrs' (
    n: v: lib.nameValuePair "wakeup.${n}" (lib.filterAttrs (_: v: v != null) v)
  ) cfg.wakeups;

  # Whether the given check is enabled
  hasCheck =
    class:
    (lib.filterAttrs (n: v: v.enabled && (if v.class == null then n else v.class) == class) cfg.checks)
    != { };

  # Dependencies needed by specific checks
  dependenciesForChecks = {
    "Smb" = pkgs.samba;
    "XIdleTime" = [
      pkgs.xprintidle
      pkgs.sudo
    ];
  };

  autosuspend-conf = settingsFormat.generate "autosuspend.conf" (
    { general = cfg.settings; } // checks // wakeups
  );

  autosuspend = cfg.package;

  checkType = lib.types.submodule {
    freeformType = settingsFormat.type.nestedTypes.elemType;

    options.enabled = lib.mkEnableOption "this activity check" // {
      default = true;
    };

    options.class = lib.mkOption {
      default = null;
      type =
        with lib.types;
        nullOr (enum [
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
      description = ''
        Name of the class implementing the check.  If this option is not specified, the check's
        name must represent a valid internal check class.
      '';
    };
  };

  wakeupType = lib.types.submodule {
    freeformType = settingsFormat.type.nestedTypes.elemType;

    options.enabled = lib.mkEnableOption "this wake-up check" // {
      default = true;
    };

    options.class = lib.mkOption {
      default = null;
      type =
        with lib.types;
        nullOr (enum [
          "Calendar"
          "Command"
          "File"
          "Periodic"
          "SystemdTimer"
          "XPath"
          "XPathDelta"
        ]);
      description = ''
        Name of the class implementing the check.  If this option is not specified, the check's
        name must represent a valid internal check class.
      '';
    };
  };
in
{
  options = {
    services.autosuspend = {
      enable = lib.mkEnableOption "the autosuspend daemon";

      package = lib.mkPackageOption pkgs "autosuspend" { };

      settings = lib.mkOption {
        type = lib.types.submodule {
          freeformType = settingsFormat.type.nestedTypes.elemType;

          options = {
            # Provide reasonable defaults for these two (required) options
            suspend_cmd = lib.mkOption {
              default = "systemctl suspend";
              type = with lib.types; str;
              description = ''
                The command to execute in case the host shall be suspended. This line can contain
                additional command line arguments to the command to execute.
              '';
            };
            wakeup_cmd = lib.mkOption {
              default = ''sh -c 'echo 0 > /sys/class/rtc/rtc0/wakealarm && echo {timestamp:.0f} > /sys/class/rtc/rtc0/wakealarm' '';
              type = with lib.types; str;
              description = ''
                The command to execute for scheduling a wake up of the system. The given string is
                processed using Python’s `str.format()` and a format argument called `timestamp`
                encodes the UTC timestamp of the planned wake up time (float). Additionally `iso`
                can be used to acquire the timestamp in ISO 8601 format.
              '';
            };
          };
        };
        default = { };
        example = lib.literalExpression ''
          {
            enable = true;
            interval = 30;
            idle_time = 120;
          }
        '';
        description = ''
          Configuration for autosuspend, see
          <https://autosuspend.readthedocs.io/en/latest/configuration_file.html#general-configuration>
          for supported values.
        '';
      };

      checks = lib.mkOption {
        default = { };
        type = with lib.types; attrsOf checkType;
        description = ''
          Checks for activity.  For more information, see:
           - <https://autosuspend.readthedocs.io/en/latest/configuration_file.html#activity-check-configuration>
           - <https://autosuspend.readthedocs.io/en/latest/available_checks.html>
        '';
        example = lib.literalExpression ''
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

      wakeups = lib.mkOption {
        default = { };
        type = with lib.types; attrsOf wakeupType;
        description = ''
          Checks for wake up.  For more information, see:
           - <https://autosuspend.readthedocs.io/en/latest/configuration_file.html#wake-up-check-configuration>
           - <https://autosuspend.readthedocs.io/en/latest/available_wakeups.html>
        '';
        example = lib.literalExpression ''
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

  config = lib.mkIf cfg.enable {
    systemd.services.autosuspend = {
      description = "A daemon to suspend your server in case of inactivity";
      documentation = [ "https://autosuspend.readthedocs.io/en/latest/systemd_integration.html" ];
      wantedBy = [ "multi-user.target" ];
      after = [ "network.target" ];
      path = lib.flatten (lib.attrValues (lib.filterAttrs (n: _: hasCheck n) dependenciesForChecks));
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
    maintainers = with lib.maintainers; [ xlambein ];
  };
}
