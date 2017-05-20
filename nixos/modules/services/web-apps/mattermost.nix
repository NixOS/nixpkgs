{ config, pkgs, lib, ... }:

with lib;

let

  cfg = config.services.mattermost;

  defaultConfig = builtins.fromJSON (readFile "${pkgs.mattermost}/config/config.json");

  mattermostConf = foldl recursiveUpdate defaultConfig
    [ { ServiceSettings.SiteURL = cfg.siteUrl;
        ServiceSettings.ListenAddress = cfg.listenAddress;
        TeamSettings.SiteName = cfg.siteName;
        SqlSettings.DriverName = "postgres";
        SqlSettings.DataSource = "postgres://${cfg.localDatabaseUser}:${cfg.localDatabasePassword}@localhost:5432/${cfg.localDatabaseName}?sslmode=disable&connect_timeout=10";
      }
      cfg.extraConfig
    ];

  mattermostConfJSON = pkgs.writeText "mattermost-config-raw.json" (builtins.toJSON mattermostConf);

in

{
  options = {
    services.mattermost = {
      enable = mkEnableOption "Mattermost chat platform";

      statePath = mkOption {
        type = types.str;
        default = "/var/lib/mattermost";
        description = "Mattermost working directory";
      };

      siteUrl = mkOption {
        type = types.str;
        example = "https://chat.example.com";
        description = ''
          URL this Mattermost instance is reachable under, without trailing slash.
        '';
      };

      siteName = mkOption {
        type = types.str;
        default = "Mattermost";
        description = "Name of this Mattermost site.";
      };

      listenAddress = mkOption {
        type = types.str;
        default = ":8065";
        example = "[::1]:8065";
        description = ''
          Address and port this Mattermost instance listens to.
        '';
      };

      mutableConfig = mkOption {
        type = types.bool;
        default = false;
        description = ''
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

      extraConfig = mkOption {
        type = types.attrs;
        default = { };
        description = ''
          Addtional configuration options as Nix attribute set in config.json schema.
        '';
      };

      localDatabaseCreate = mkOption {
        type = types.bool;
        default = true;
        description = ''
          Create a local PostgreSQL database for Mattermost automatically.
        '';
      };

      localDatabaseName = mkOption {
        type = types.str;
        default = "mattermost";
        description = ''
          Local Mattermost database name.
        '';
      };

      localDatabaseUser = mkOption {
        type = types.str;
        default = "mattermost";
        description = ''
          Local Mattermost database username.
        '';
      };

      localDatabasePassword = mkOption {
        type = types.str;
        default = "mmpgsecret";
        description = ''
          Password for local Mattermost database user.
        '';
      };

      user = mkOption {
        type = types.str;
        default = "mattermost";
        description = ''
          User which runs the Mattermost service.
        '';
      };

      group = mkOption {
        type = types.str;
        default = "mattermost";
        description = ''
          Group which runs the Mattermost service.
        '';
      };

      matterircd = {
        enable = mkEnableOption "Mattermost IRC bridge";
        parameters = mkOption {
          type = types.listOf types.str;
          default = [ ];
          example = [ "-mmserver chat.example.com" "-bind [::]:6667" ];
          description = ''
            Set commandline parameters to pass to matterircd. See
            https://github.com/42wim/matterircd#usage for more information.
          '';
        };
      };
    };
  };

  config = mkMerge [
    (mkIf cfg.enable {
      users.extraUsers = optionalAttrs (cfg.user == "mattermost") (singleton {
        name = "mattermost";
        group = cfg.group;
        uid = config.ids.uids.mattermost;
        home = cfg.statePath;
      });

      users.extraGroups = optionalAttrs (cfg.group == "mattermost") (singleton {
        name = "mattermost";
        gid = config.ids.gids.mattermost;
      });

      services.postgresql.enable = cfg.localDatabaseCreate;

      # The systemd service will fail to execute the preStart hook
      # if the WorkingDirectory does not exist
      system.activationScripts.mattermost = ''
        mkdir -p ${cfg.statePath}
      '';

      systemd.services.mattermost = {
        description = "Mattermost chat platform service";
        wantedBy = [ "multi-user.target" ];
        after = [ "network.target" "postgresql.service" ];

        preStart = ''
          mkdir -p ${cfg.statePath}/{data,config,logs}
          ln -sf ${pkgs.mattermost}/{bin,fonts,i18n,templates,webapp} ${cfg.statePath}
        '' + lib.optionalString (!cfg.mutableConfig) ''
          ln -sf ${mattermostConfJSON} ${cfg.statePath}/config/config.json
        '' + lib.optionalString cfg.mutableConfig ''
          if ! test -e "${cfg.statePath}/config/.initial-created"; then
            rm -f ${cfg.statePath}/config/config.json
            cp ${mattermostConfJSON} ${cfg.statePath}/config/config.json
            touch ${cfg.statePath}/config/.initial-created
          fi
        '' + lib.optionalString cfg.localDatabaseCreate ''
          if ! test -e "${cfg.statePath}/.db-created"; then
            ${config.services.postgresql.package}/bin/psql postgres -c \
              "CREATE ROLE ${cfg.localDatabaseUser} WITH LOGIN NOCREATEDB NOCREATEROLE NOCREATEUSER ENCRYPTED PASSWORD '${cfg.localDatabasePassword}'"
            ${config.services.postgresql.package}/bin/createdb \
              --owner ${cfg.localDatabaseUser} ${cfg.localDatabaseName}
            touch ${cfg.statePath}/.db-created
          fi
        '' + ''
          chown ${cfg.user}:${cfg.group} -R ${cfg.statePath}
          chmod u+rw,g+r,o-rwx -R ${cfg.statePath}
        '';

        serviceConfig = {
          PermissionsStartOnly = true;
          User = cfg.user;
          Group = cfg.group;
          ExecStart = "${pkgs.mattermost}/bin/mattermost-platform";
          WorkingDirectory = "${cfg.statePath}";
          JoinsNamespaceOf = mkIf cfg.localDatabaseCreate "postgresql.service";
          Restart = "always";
          RestartSec = "10";
          LimitNOFILE = "49152";
        };
      };
    })
    (mkIf cfg.matterircd.enable {
      systemd.services.matterircd = {
        description = "Mattermost IRC bridge service";
        wantedBy = [ "multi-user.target" ];
        serviceConfig = {
          User = "nobody";
          Group = "nogroup";
          ExecStart = "${pkgs.matterircd.bin}/bin/matterircd ${concatStringsSep " " cfg.matterircd.parameters}";
          WorkingDirectory = "/tmp";
          PrivateTmp = true;
          Restart = "always";
          RestartSec = "5";
        };
      };
    })
  ];
}

