{ config, options, pkgs, lib, ... }:

with lib;

let

  description = "Parity Daemon";

  cu = pkgs.coreutils;

  cfg = config.services.parity;
  opts = options.services.parity;

  configFile = optionalString (!isNull cfg.extraConfig) (" --config=${pkgs.writeText "config.toml" cfg.extraConfig}");

in

{

  options = {

    services.parity = {

      enable = mkOption {
        type = types.bool;
        default = false;
        description = "Enable ${description}";
      };

      package = mkOption {
        default = pkgs.altcoins.parity;
        type = types.package;
      };

      user = mkOption {
         default = "parity";
         defaultText = "Parity daemon user"; 
         type = types.str;
      };

      group = mkOption {
         default = "parity";
         defaultText = "Parity daemon group";
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

    systemd.services.parity = {

      inherit description;
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];

      serviceConfig = {
        User = cfg.user;
        Group = cfg.group;
        WorkingDirectory = cfg.dataDir;

        ExecStart = "${cfg.package}/bin/parity${configFile} --base-path=${cfg.dataDir}";

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
        description = opts.user.defaultText;
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
