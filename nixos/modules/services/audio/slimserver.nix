{ config, lib, pkgs, ... }:

with lib;

let

  cfg = config.services.slimserver;

in {
  options = {

    services.slimserver = {

      enable = mkOption {
        type = types.bool;
        default = false;
        description = ''
          Whether to enable slimserver.
        '';
      };

      package = mkOption {
        type = types.package;
        default = pkgs.slimserver;
        defaultText = "pkgs.slimserver";
        description = "Slimserver package to use.";
      };

      dataDir = mkOption {
        type = types.path;
        default = "/var/lib/slimserver";
        description = ''
          The directory where slimserver stores its state, tag cache,
          playlists etc.
        '';
      };
    };
  };


  ###### implementation

  config = mkIf cfg.enable {

    systemd.services.slimserver = {
      after = [ "network.target" ];
      description = "Slim Server for Logitech Squeezebox Players";
      wantedBy = [ "multi-user.target" ];

      preStart = "mkdir -p ${cfg.dataDir} && chown -R slimserver:slimserver ${cfg.dataDir}";
      serviceConfig = {
        User = "slimserver";
        PermissionsStartOnly = true;
        ExecStart = "${cfg.package}/slimserver.pl --logdir ${cfg.dataDir}/logs --prefsdir ${cfg.dataDir}/prefs --cachedir ${cfg.dataDir}/cache";
      };
    };

    users = {
      users.slimserver = {
        description = "Slimserver daemon user";
        home = cfg.dataDir;
        group = "slimserver";
      };
      groups.slimserver = {};
    };
  };

}

