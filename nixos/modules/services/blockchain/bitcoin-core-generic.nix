{ config, options, pkgs, lib
, name
, description
, defaultUser
, userDescription
, defaultGroup
, groupDescription
, defaultPackage
, daemonExec
, cliExec
, ... }:

with lib;

let

  stateDir = "/var/lib/${name}";
  pidFile = "${stateDir}/${name}.pid";

  cu = pkgs.coreutils;

  cfg = config.services.${name};
  opts = options.services.${name};

  configFile = optionalString (!isNull cfg.extraConfig) (" -conf=${pkgs.writeText "${name}.conf" cfg.extraConfig}");

in

{

  options = {

    services.${name} = {

      enable = mkOption {
        default = false;
        description = "Enable ${description}";
        type = types.bool;
      };

      package = mkOption {
        default = defaultPackage;
        description = "Package to use";
        type = types.package;
      };

      user = mkOption {
         default = defaultUser;
         description = userDescription;
         type = types.str;
      };

      group = mkOption {
         default = defaultGroup;
         description = groupDescription;
         type = types.str;
      };

      dataDir = mkOption {
        description = "Data directory";
        type = types.path;
      };

      extraConfig = mkOption {
        description = "Additional configuration";
        type = types.nullOr types.str;
      };

    };

  };

  config = mkIf cfg.enable {

    systemd.services.${name} = {

      inherit description;
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];

      serviceConfig = {
        User = cfg.user;
        Group = cfg.group;
        WorkingDirectory = cfg.dataDir;

        Type = "forking";
        PIDFile = pidFile;

        ExecStartPre = [
          "+${cu}/bin/mkdir -p ${stateDir}"
          "+${cu}/bin/chown -R ${cfg.user}:${cfg.group} ${stateDir}"
          "+${cu}/bin/chmod -R 700 ${stateDir}"
        ];
        ExecStart = "${cfg.package}/bin/${daemonExec} -daemon -pid=${pidFile} -datadir=${cfg.dataDir}${configFile}";
        ExecStop = "${cfg.package}/bin/${cliExec} -rpcwait -datadir=${cfg.dataDir}${configFile} stop";

        Restart = "always";
        PrivateTmp = true;
        TimeoutStopSec = 60;
      };
    };

    users = {
      extraUsers = optionalAttrs (cfg.user == opts.user.default) (singleton {
        name = opts.user.default;
        uid = config.ids.uids.${opts.user.default};
        group = opts.group.default;
        description = opts.user.description;
        home = cfg.dataDir;
        createHome = true;
      });

      extraGroups = optionalAttrs (cfg.group == opts.group.default) (singleton {
        name = opts.group.default;
        gid = config.ids.gids.${opts.group.default};
      });
    };

    environment.systemPackages = [ cfg.package ];

  };

}
