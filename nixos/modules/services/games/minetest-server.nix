{ config, lib, pkgs, ... }:

with lib;

let
  cfg   = config.services.minetest-server;
  flag  = val: name: if val != null then "--${name} ${val} " else "";
  flags = [ 
    (flag cfg.gameId "gameid") 
    (flag cfg.world "world") 
    (flag cfg.configPath "config") 
    (flag cfg.logPath "logfile") 
    (flag cfg.port "port") 
  ];
in
{
  options = {
    services.minetest-server = {
      enable = mkOption {
        type        = types.bool;
        default     = false;
        description = "If enabled, starts a Minetest Server.";
      };

      gameId = mkOption {
        type        = types.nullOr types.str;
        default     = null;
        description = ''
          Id of the game to use. To list available games run 
          `minetestserver --gameid list`.

          If only one game exists, this option can be null.
        '';
      };

      world = mkOption {
        type        = types.nullOr types.path;
        default     = null;
        description = ''
          Name of the world to use. To list available worlds run
          `minetestserver --world list`.

          If only one world exists, this option can be null.
        '';
      };

      configPath = mkOption {
        type        = types.nullOr types.path;
        default     = null;
        description = ''
          Path to the config to use.

          If set to null, the config of the running user will be used:
          `~/.minetest/minetest.conf`.
        '';
      };

      logPath = mkOption {
        type        = types.nullOr types.path;
        default     = null;
        description = ''
          Path to logfile for logging. 

          If set to null, logging will be output to stdout which means
          all output will be catched by systemd.
        '';
      };

      port = mkOption {
        type        = types.nullOr types.int;
        default     = null;
        description = ''
          Port number to bind to.

          If set to null, the default 30000 will be used.
        '';
      };
    };
  };

  config = mkIf cfg.enable {
    users.extraUsers.minetest = {
      description     = "Minetest Server Service user";
      home            = "/var/lib/minetest";
      createHome      = true;
      uid             = config.ids.uids.minetest;
    };

    systemd.services.minetest-server = {
      description   = "Minetest Server Service";
      wantedBy      = [ "multi-user.target" ];
      after         = [ "network.target" ];

      serviceConfig.Restart = "always";
      serviceConfig.User    = "minetest";

      script = ''
        cd /var/lib/minetest

        exec ${pkgs.minetest}/bin/minetest --server ${concatStrings flags}
      '';
    };
  };
}
