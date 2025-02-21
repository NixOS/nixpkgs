{
  config,
  pkgs,
  lib,
  utils,
  ...
}:
let
  cfg = config.services.sonarr;
  servarr = import ./servarr/settings-options.nix { inherit lib pkgs; };
in
{
  options = {
    services.sonarr = {
      enable = lib.mkEnableOption "Sonarr";

      dataDir = lib.mkOption {
        type = lib.types.str;
        default = "/var/lib/sonarr/.config/NzbDrone";
        description = "The directory where Sonarr stores its data files.";
      };

      openFirewall = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = ''
          Open ports in the firewall for the Sonarr web interface
        '';
      };

      apiKeyFile = lib.mkOption {
        type = lib.types.nullOr lib.types.path;
        description = ''
          Path to the file containing the API key for Sonarr (32 chars).
          This will overwrite the API key in the config file.
        '';
        example = "/run/secrets/sonarr-apikey";
        default = null;
      };

      environmentFiles = lib.mkOption {
        type = lib.types.listOf lib.types.path;
        default = [ ];
        description = ''
          Environment file to pass secret configuration values.

          Each line must follow the `SONARR__SECTION__KEY=value` pattern.
          Please consult the documentation at the [wiki](https://wiki.servarr.com/useful-tools#using-environment-variables-for-config).
        '';
      };

      settings = servarr.mkServarrSettingsOptions "sonarr" 8989;

      user = lib.mkOption {
        type = lib.types.str;
        default = "sonarr";
        description = "User account under which Sonaar runs.";
      };

      group = lib.mkOption {
        type = lib.types.str;
        default = "sonarr";
        description = "Group under which Sonaar runs.";
      };

      package = lib.mkPackageOption pkgs "sonarr" { };
    };
  };

  config = lib.mkIf cfg.enable {
    assertions = [
      {
        assertion = !(cfg.settings ? auth && cfg.settings.auth ? apikey);
        message = ''
          The `services.sonarr.settings` attribute set must not contain `ApiKey`, you should instead use `services.sonarr.apiKeyFile` to avoid storing secrets in the Nix store.
        '';
      }
    ];

    systemd.tmpfiles.rules = [
      "d '${cfg.dataDir}' 0700 ${cfg.user} ${cfg.group} - -"
    ];

    systemd.services.sonarr = {
      description = "Sonarr";
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];
      environment = servarr.mkServarrSettingsEnvVars "SONARR" cfg.settings;
      serviceConfig = {
        Type = "simple";
        User = cfg.user;
        Group = cfg.group;
        EnvironmentFile = cfg.environmentFiles;
        LoadCredential = lib.optional (cfg.apiKeyFile != null) "SONARR__AUTH__APIKEY:${cfg.apiKeyFile}";
        ExecStartPre = lib.optionalString (cfg.apiKeyFile != null) pkgs.writeShellScript "sonarr-apikey" ''
          if [ ! -s config.xml ]; then
            echo '<?xml version="1.0" encoding="UTF-8"?><Config><ApiKey></ApiKey></Config>' > "${cfg.dataDir}/config.xml"
          fi
          ${lib.getExe pkgs.xmlstarlet} ed -L -u "/Config/ApiKey" -v "@API_KEY@" "${cfg.dataDir}/config.xml"
          ${lib.getExe pkgs.replace-secret} '@API_KEY@' ''${CREDENTIALS_DIRECTORY}/SONARR__AUTH__APIKEY "${cfg.dataDir}/config.xml"
        '';
        ExecStart = utils.escapeSystemdExecArgs [
          (lib.getExe cfg.package)
          "-nobrowser"
          "-data=${cfg.dataDir}"
        ];
        Restart = "on-failure";
      };
    };

    networking.firewall = lib.mkIf cfg.openFirewall {
      allowedTCPPorts = [ cfg.settings.server.port ];
    };

    users.users = lib.mkIf (cfg.user == "sonarr") {
      sonarr = {
        group = cfg.group;
        home = cfg.dataDir;
        uid = config.ids.uids.sonarr;
      };
    };

    users.groups = lib.mkIf (cfg.group == "sonarr") {
      sonarr.gid = config.ids.gids.sonarr;
    };
  };
}
