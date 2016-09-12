{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.errbot;
  pluginEnv = plugins: pkgs.buildEnv {
    name = "errbot-plugins";
    paths = plugins;
  };
  mkConfigFile = instanceCfg: dataDir: pkgs.writeText "errbot-config.py" ''
    import logging
    BACKEND = '${instanceCfg.backend}'
    BOT_DATA_DIR = '${dataDir}'
    BOT_EXTRA_PLUGIN_DIR = '${pluginEnv instanceCfg.plugins}'

    BOT_LOG_LEVEL = logging.${instanceCfg.logLevel}
    BOT_LOG_FILE = False

    BOT_ADMINS = (${concatMapStringsSep "," (name: "'${name}'") instanceCfg.admins})

    BOT_IDENTITY = ${instanceCfg.identity}

    ${instanceCfg.extraConfig}
  '';
in {
  options = {
    services.errbot.instances = mkOption {
      default = {};
      description = "Errbot instance configs";
      type = types.attrsOf (types.submodule {
        options = {
          dataDir = mkOption {
            type = types.nullOr types.str;
            default = null;
            description = "Gitlab state directory, logs are stored here.";
          };

          plugins = mkOption {
            type = types.listOf types.path;
            default = [];
            description = "Gitlab path for backups.";
          };

          logLevel = mkOption {
            type = types.str;
            default = "DEBUG";
            description = "Gitlab database hostname.";
          };

          admins = mkOption {
            type = types.listOf types.str;
            default = [];
            description = "Gitlab database user password.";
          };

          backend = mkOption {
            type = types.str;
            default = "XMPP";
            description = "Gitlab database name.";
          };

          identity = mkOption {
            type = types.str;
            default = "{}";
            description = "Gitlab database user.";
          };

          extraConfig = mkOption {
            type = types.lines;
            default = "";
            description = "extraConfig";
          };
        };
      });
    };
  };

  config = mkIf (cfg.instances != {}) {
    users.extraUsers.errbot.group = "errbot";
    users.extraGroups.errbot = {};

    systemd.services = mapAttrs' (name: instanceCfg: nameValuePair "errbot-${name}" (
    let
      dataDir = if !isNull instanceCfg.dataDir then instanceCfg.dataDir else
        "/var/lib/errbot/${name}";
    in {
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];
      preStart = ''
        mkdir -p ${dataDir}
        chown -R errbot:errbot ${dataDir}
      '';
      serviceConfig = {
        Type = "simple";
        User = "errbot";
        Group = "errbot";
        Restart = "on-failure";
        ExecStart="${pkgs.errbot}/bin/errbot -c ${mkConfigFile instanceCfg dataDir}";
        PermissionsStartOnly = true;
      };
    })) cfg.instances;
  };
}
