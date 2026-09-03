{
  config,
  pkgs,
  lib,
  ...
}:
let
  cfg = config.services.soularr;
  ini = pkgs.formats.ini { };
in
{
  options = {
    services.soularr = {
      enable = lib.mkEnableOption "Soularr, a script that connects Lidarr with Soulseek";

      package = lib.mkPackageOption pkgs "soularr" { };

      settings = lib.mkOption {
        type = lib.types.submodule {
          freeformType = ini.type;
        };
        example = lib.options.literalExpression ''
          {
            Lidarr = {
              host_url = "http://localhost:8686";
              download_dir = "/media/slsk/downloads";
            };
            Slskd = {
              host_url = "http://localhost:5030";
              download_dir = "/media/slsk/downloads";
            };
            "Search Settings" = {
              search_source = "missing";
              minimum_filename_match_ratio = 0.8;
            };
            "Release Settings" = {
              use_selected_lidarr_release = true;
            };
          }
        '';
        default = { };
        description = ''
          Attribute set of arbitrary config options.
          Please consult the example on the [official website](https://soularr.net/#configure-your-config-file).
        '';
      };

      lidarrApiKeyFile = lib.mkOption {
        type = lib.types.path;
        description = "Path to the file containing Lidarr's api-key.";
      };

      slskdApiKeyFile = lib.mkOption {
        type = lib.types.path;
        description = "Path to the file containing Slskd's api-key.";
      };

      interval = lib.mkOption {
        type = lib.types.str;
        default = "hourly";
        description = ''
          The interval at which the Soularr should run. See
          {manpage}`systemd.time(7)` to understand the format.
        '';
      };

      user = lib.mkOption {
        type = lib.types.str;
        default = "soularr";
        description = ''
          User account under which Soularr runs.
        '';
      };

      group = lib.mkOption {
        type = lib.types.str;
        default = "soularr";
        description = ''
          Group under which Soularr runs.
        '';
      };
    };
  };

  config = lib.mkIf cfg.enable {
    assertions = [
      {
        assertion = !lib.hasAttrByPath [ "Lidarr" "api_key" ] cfg.settings;
        message = ''
          Do not set `services.soularr.settings.Lidarr.api_key` in your configuration.
          Use `services.soularr.lidarrApiKeyFile` instead.
        '';
      }
      {
        assertion = !lib.hasAttrByPath [ "Slskd" "api_key" ] cfg.settings;
        message = ''
          Do not set `services.soularr.settings.Slskd.api_key` in your configuration.
          Use `services.soularr.slskdApiKeyFile` instead.
        '';
      }
    ];

    systemd.services.soularr = {
      description = "Soularr";
      after = [
        "network.target"
      ]
      ++ lib.optional config.services.lidarr.enable "lidarr.service"
      ++ lib.optional config.services.slskd.enable "slskd.service";

      restartIfChanged = false;

      preStart =
        let
          configFile = ini.generate "config.ini" (
            lib.recursiveUpdate cfg.settings {
              Lidarr.api_key = "@LIDARR_API_KEY@";
              Slskd.api_key = "@SLSKD_API_KEY@";
            }
          );
        in
        ''
          install -m 700 '${configFile}' "$RUNTIME_DIRECTORY/config.ini"
          ${lib.getExe pkgs.replace-secret} "@LIDARR_API_KEY@" "$CREDENTIALS_DIRECTORY/LIDARR_API_KEY" "$RUNTIME_DIRECTORY/config.ini"
          ${lib.getExe pkgs.replace-secret} "@SLSKD_API_KEY@" "$CREDENTIALS_DIRECTORY/SLSKD_API_KEY" "$RUNTIME_DIRECTORY/config.ini"
        '';

      serviceConfig = {
        Type = "oneshot";
        RuntimeDirectory = "soularr";
        WorkingDirectory = "/run/soularr";
        User = cfg.user;
        Group = cfg.group;
        LoadCredential = [
          "LIDARR_API_KEY:${cfg.lidarrApiKeyFile}"
          "SLSKD_API_KEY:${cfg.slskdApiKeyFile}"
        ];
        ExecStart = "${lib.getExe cfg.package}";
        Restart = "on-failure";
      };
    };

    systemd.timers.soularr = {
      timerConfig = {
        OnCalendar = cfg.interval;
        Persistent = true;
      };
      wantedBy = [ "timers.target" ];
    };

    users.users = lib.mkIf (cfg.user == "soularr") {
      soularr = {
        group = cfg.group;
        uid = config.ids.uids.soularr;
      };
    };

    users.groups = lib.mkIf (cfg.group == "soularr") {
      soularr = {
        gid = config.ids.gids.soularr;
      };
    };
  };
}
