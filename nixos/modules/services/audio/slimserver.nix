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

    systemd.tmpfiles.rules = [
      "d '${cfg.dataDir}' - slimserver slimserver - -"
    ];

    systemd.services.slimserver = {
      after = [ "network.target" ];
      description = "Slim Server for Logitech Squeezebox Players";
      wantedBy = [ "multi-user.target" ];

      serviceConfig = {
        User = "slimserver";
        # Issue 40589: Disable broken image/video support (audio still works!)
        ExecStart = "${cfg.package}/slimserver.pl --logdir ${cfg.dataDir}/logs --prefsdir ${cfg.dataDir}/prefs --cachedir ${cfg.dataDir}/cache --noimage --novideo";
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

