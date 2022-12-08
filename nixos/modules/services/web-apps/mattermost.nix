{ config, pkgs, lib, ... }:

with lib;

let
  cfg = config.services.mattermost;

  mattermostConf = recursiveUpdate
    {
      ServiceSettings.SiteURL = cfg.siteUrl;
      ServiceSettings.ListenAddress = "${cfg.listenAddress}:${toString cfg.port}";
      TeamSettings.SiteName = cfg.siteName;
      SqlSettings.DriverName = "postgres";
      SqlSettings.DataSource = "postgres:///${cfg.database.name}?host=/run/postgresql";
      FileSettings.Directory = cfg.dataDir;
      PluginSettings.Directory = "${cfg.dataDir}/plugins/server";
      PluginSettings.ClientDirectory = "${cfg.dataDir}/plugins/client";
      LogSettings.FileLocation = cfg.logDir;
    }
    cfg.settings;

  mattermostConfJSON = (pkgs.formats.json { }).generate "mattermost-config.json" mattermostConf;
in
{
  imports = [
    (mkRemovedOptionModule [ "services" "mattermost" "plugins" ] "Plugin support has been removed as its fundamentally to get it working without patchelfing and patching Mattermost's Go code.")
    (mkRemovedOptionModule [ "services" "mattermost" "matterircd" "enable" ] "This option has been removed as it shouldn't be part of the Mattermost module.")
    (mkRemovedOptionModule [ "services" "mattermost" "matterircd" "package" ] "This option has been removed as it shouldn't be part of the Mattermost module.")
    (mkRemovedOptionModule [ "services" "mattermost" "matterircd" "parameters" ] "This option has been removed as it shouldn't be part of the Mattermost module.")
    (mkRemovedOptionModule [ "services" "mattermost" "localDatabaseCreate" ] "The PostgreSQL database now gets created automatically by default.")
    (mkRemovedOptionModule [ "services" "mattermost" "localDatabasePassword" ] "The database is no longer secured via password but rather with UNIX user authentication.")
    (mkRemovedOptionModule [ "services" "mattermost" "localDatabaseUser" ] "The database user now matches the user under which Mattermost runs under.")
    (mkRenamedOptionModule [ "services" "mattermost" "localDatabaseName" ] [ "services" "mattermost" "database" "name" ])
    (mkRenamedOptionModule [ "services" "mattermost" "extraConfig" ] [ "services" "mattermost" "settings" ])
    (mkRenamedOptionModule [ "services" "mattermost" "statePath" ] [ "services" "mattermost" "dataDir" ])
  ];

  options = {
    services.mattermost = {
      enable = mkEnableOption (lib.mdDoc "Mattermost chat server");

      package = mkPackageOption pkgs "mattermost" { };

      user = mkOption {
        type = types.str;
        default = "mattermost";
        description = lib.mdDoc "User account under which Mattermost runs.";
      };

      group = mkOption {
        type = types.str;
        default = "mattermost";
        description = lib.mdDoc "Group under which Mattermost runs.";
      };

      listenAddress = mkOption {
        type = types.str;
        default = "127.0.0.1";
        example = "0.0.0.0";
        description = lib.mdDoc "Address for Mattermost server to listens on.";
      };

      port = mkOption {
        type = types.port;
        default = 8065;
        description = lib.mdDoc "Port for Mattermost server to listens on.";
      };

      dataDir = mkOption {
        type = types.str;
        default = "/var/lib/mattermost";
        description = lib.mdDoc "Mattermost working directory";
      };

      logDir = mkOption {
        type = types.str;
        default = "/var/log/mattermost";
        description = lib.mdDoc "Mattermost logs directory";
      };

      configDir = mkOption {
        type = types.str;
        default = "/etc/mattermost";
        description = lib.mdDoc "Mattermost config directory";
      };

      database = {
        name = mkOption {
          type = types.str;
          default = "mattermost";
          description = lib.mdDoc "Local Mattermost database name.";
        };
      };

      siteUrl = mkOption {
        type = types.str;
        example = "https://chat.example.com";
        description = lib.mdDoc "URL the Mattermost instance is reachable under, without trailing slash.";
      };

      siteName = mkOption {
        type = types.str;
        default = "Mattermost";
        description = lib.mdDoc "Name of the Mattermost site.";
      };

      mutableConfig = mkOption {
        type = types.bool;
        default = false;
        description = lib.mdDoc ''
          Whether the Mattermost config.json is writeable by Mattermost.

          Most of the settings can be edited in the system console of
          Mattermost if this option is enabled. A template config using
          the options specified in services.mattermost will be generated
          but won't be overwritten on changes or rebuilds.

          If this option is disabled, changes in the system console won't
          be possible (default). If an config.json is present, it will be
          overwritten!
        '';
      };

      preferNixConfig = mkOption {
        type = types.bool;
        default = false;
        description = lib.mdDoc ''
          If both mutableConfig and this option are set, the Nix configuration
          will take precedence over any settings configured in the server
          console.
        '';
      };

      settings = mkOption {
        type = types.attrs;
        default = { };
        description = lib.mdDoc "Addtional configuration options as Nix attribute set in config.json schema.";
      };
    };
  };

  config = mkIf cfg.enable {
    users.users.${cfg.user} = {
      home = cfg.dataDir;
      group = cfg.group;
      isSystemUser = true;
    };

    users.groups.${cfg.group} = { };

    services.postgresql = {
      enable = true;
      ensureDatabases = [ cfg.database.name ];
      ensureUsers = [{
        name = cfg.user;
        ensurePermissions."DATABASE ${cfg.database.name}" = "ALL PRIVILEGES";
      }];
    };

    systemd.tmpfiles.rules = [
      "d ${cfg.dataDir} 0750 ${cfg.user} ${cfg.group} - -"
      "d ${cfg.logDir} 0750 ${cfg.user} ${cfg.group} - -"
      "d ${cfg.configDir} 0750 ${cfg.user} ${cfg.group} - -"
      "d ${mattermostConf.PluginSettings.Directory} 0750 ${cfg.user} ${cfg.group} - -"
      "d ${mattermostConf.PluginSettings.ClientDirectory} 0750 ${cfg.user} ${cfg.group} - -"
      "L+ ${cfg.dataDir}/fonts - - - - ${cfg.package}/fonts"
      "L+ ${cfg.dataDir}/i18n - - - - ${cfg.package}/i18n"
      "L+ ${cfg.dataDir}/templates - - - - ${cfg.package}/templates"
      "L+ ${cfg.dataDir}/client - - - - ${cfg.package}/client"
    ];

    systemd.services.mattermost = {
      description = "Mattermost chat service";
      wantedBy = [ "multi-user.target" ];
      after = [ "network.target" "postgresql.service" ];
      requires = [ "network.target" "postgresql.service" ];

      preStart = lib.optionalString (!cfg.mutableConfig) ''
        ${pkgs.jq}/bin/jq -s '.[0] * .[1]' ${cfg.package}/config/config.json ${mattermostConfJSON} > "${cfg.configDir}/config.json"
      '' + lib.optionalString cfg.mutableConfig ''
        if ! test -e "${cfg.configDir}/.initial-created"; then
          ${pkgs.jq}/bin/jq -s '.[0] * .[1]' ${cfg.package}/config/config.json ${mattermostConfJSON} > "${cfg.configDir}/config.json"
          touch "${cfg.configDir}/.initial-created"
        fi
      '' + lib.optionalString (cfg.mutableConfig && cfg.preferNixConfig) ''
        echo "$(${pkgs.jq}/bin/jq -s '.[0] * .[1]' "${cfg.configDir}/config.json" ${mattermostConfJSON})" > "${cfg.configDir}/config.json"
      '';

      serviceConfig = mkMerge [{
        User = cfg.user;
        Group = cfg.group;
        ExecStart = "${cfg.package}/bin/mattermost --config ${cfg.configDir}/config.json";
        ReadWritePaths = [ cfg.dataDir cfg.logDir cfg.configDir ];
        UMask = "0027";
        Restart = "always";
        RestartSec = 10;
        LimitNOFILE = 49152;
        LockPersonality = true;
        NoNewPrivileges = true;
        PrivateDevices = true;
        PrivateTmp = true;
        PrivateUsers = true;
        ProtectClock = true;
        ProtectControlGroups = true;
        ProtectHome = true;
        ProtectHostname = true;
        ProtectKernelLogs = true;
        ProtectKernelModules = true;
        ProtectKernelTunables = true;
        ProtectProc = "invisible";
        ProtectSystem = "strict";
        RestrictNamespaces = true;
        RestrictSUIDSGID = true;
      }
        (mkIf (cfg.dataDir == "/var/lib/mattermost") {
          StateDirectory = baseNameOf cfg.dataDir;
          StateDirectoryMode = "0750";
        })
        (mkIf (cfg.logDir == "/var/log/mattermost") {
          LogsDirectory = baseNameOf cfg.logDir;
          LogsDirectoryMode = "0750";
        })
        (mkIf (cfg.configDir == "/etc/mattermost") {
          ConfigurationDirectory = baseNameOf cfg.configDir;
          ConfigurationDirectoryMode = "0750";
        })];
    };

    assertions = [{ assertion = !(lib.hasInfix ":" cfg.listenAddress); message = "listenAddress should not include a port, use services.mattermost.port to specify the port."; }];
  };

  meta.maintainers = with lib.maintainers; [ kranzes ];
}
