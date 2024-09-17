{
  config,
  pkgs,
  lib,
  utils,
  ...
}:
let
  cfg = config.services.sonarr;

  settingsFormat = pkgs.formats.xml { };
  settingsDefault = {
    Port = 8989;
    BindAddress = "*";
    AuthenticationMethod = "None";
    UpdateMechanism = "external";
  };
  settingsCombined = settingsDefault // cfg.settings;

  # add empty ApiKey so it can be replaced afterwards
  configContent =
    settingsCombined // (lib.optionalAttrs (cfg.apiKeyFile != null) { ApiKey = "@APIKEY@"; });
  configFile = settingsFormat.generate "sonarr-config.xml" { Config = configContent; };
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

      settings = lib.mkOption {
        inherit (settingsFormat) type;
        description = "An attribute set containing Sonarr configuration settings.";
        default = settingsDefault;
        example = {
          LogLevel = "info";
          EnableSsl = "False";
          Port = 8989;
          SslPort = 9898;
          UrlBase = "";
          BindAddress = "*";
          AuthenticationMethod = "None";
          UpdateMechanism = "external";
          Branch = "main";
          InstanceName = "Sonarr";
        };
      };

      apiKeyFile = lib.mkOption {
        type = lib.types.nullOr lib.types.path;
        description = "Path to the file containing the API key for Sonarr (32 chars).";
        example = "/run/secrets/sonarr-apikey";
        default = null;
      };

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
        assertion = !(builtins.hasAttr "ApiKey" cfg.settings);
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
      reloadTriggers = [ configFile ];

      serviceConfig = {
        Type = "simple";
        User = cfg.user;
        Group = cfg.group;
        # set config file in pre
        ExecStartPre =
          [
            "${pkgs.coreutils}/bin/install -o ${cfg.user} -g ${cfg.group} ${configFile} ${cfg.dataDir}/config.xml"
          ]
          ++ lib.optional (cfg.apiKeyFile != null)
            "${pkgs.replace-secret}/bin/replace-secret '@APIKEY@' '${cfg.apiKeyFile}' ${cfg.dataDir}/config.xml";
        ExecStart = utils.escapeSystemdExecArgs [
          (lib.getExe cfg.package)
          "-nobrowser"
          "-data=${cfg.dataDir}"
        ];
        Restart = "on-failure";
      };
    };

    networking.firewall = lib.mkIf cfg.openFirewall {
      allowedTCPPorts = [ settingsCombined.Port ];
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
