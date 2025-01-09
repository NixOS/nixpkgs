{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.services.errbot;
  pluginEnv =
    plugins:
    pkgs.buildEnv {
      name = "errbot-plugins";
      paths = plugins;
    };
  mkConfigDir =
    instanceCfg: dataDir:
    pkgs.writeTextDir "config.py" ''
      import logging
      BACKEND = '${instanceCfg.backend}'
      BOT_DATA_DIR = '${dataDir}'
      BOT_EXTRA_PLUGIN_DIR = '${pluginEnv instanceCfg.plugins}'

      BOT_LOG_LEVEL = logging.${instanceCfg.logLevel}
      BOT_LOG_FILE = False

      BOT_ADMINS = (${lib.concatMapStringsSep "," (name: "'${name}'") instanceCfg.admins})

      BOT_IDENTITY = ${builtins.toJSON instanceCfg.identity}

      ${instanceCfg.extraConfig}
    '';
in
{
  options = {
    services.errbot.instances = lib.mkOption {
      default = { };
      description = "Errbot instance configs";
      type = lib.types.attrsOf (
        lib.types.submodule {
          options = {
            dataDir = lib.mkOption {
              type = lib.types.nullOr lib.types.path;
              default = null;
              description = "Data directory for errbot instance.";
            };

            plugins = lib.mkOption {
              type = lib.types.listOf lib.types.package;
              default = [ ];
              description = "List of errbot plugin derivations.";
            };

            logLevel = lib.mkOption {
              type = lib.types.str;
              default = "INFO";
              description = "Errbot log level";
            };

            admins = lib.mkOption {
              type = lib.types.listOf lib.types.str;
              default = [ ];
              description = "List of identifiers of errbot admins.";
            };

            backend = lib.mkOption {
              type = lib.types.str;
              default = "XMPP";
              description = "Errbot backend name.";
            };

            identity = lib.mkOption {
              type = lib.types.attrs;
              description = "Errbot identity configuration";
            };

            extraConfig = lib.mkOption {
              type = lib.types.lines;
              default = "";
              description = "String to be appended to the config verbatim";
            };
          };
        }
      );
    };
  };

  config = lib.mkIf (cfg.instances != { }) {
    users.users.errbot = {
      group = "errbot";
      isSystemUser = true;
    };
    users.groups.errbot = { };

    systemd.services = lib.mapAttrs' (
      name: instanceCfg:
      lib.nameValuePair "errbot-${name}" (
        let
          dataDir = if instanceCfg.dataDir != null then instanceCfg.dataDir else "/var/lib/errbot/${name}";
        in
        {
          after = [ "network-online.target" ];
          wantedBy = [ "multi-user.target" ];
          preStart = ''
            mkdir -p ${dataDir}
            chown -R errbot:errbot ${dataDir}
          '';
          serviceConfig = {
            User = "errbot";
            Restart = "on-failure";
            ExecStart = "${pkgs.errbot}/bin/errbot -c ${mkConfigDir instanceCfg dataDir}/config.py";
            PermissionsStartOnly = true;
          };
        }
      )
    ) cfg.instances;
  };
}
