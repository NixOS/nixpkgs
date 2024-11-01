{ config, pkgs, lib, ... }:
let
  cfg = config.services.leaps;
  stateDir = "/var/lib/leaps/";
in
{
  options = {
    services.leaps = {
      enable = lib.mkEnableOption "leaps, a pair programming service";
      port = lib.mkOption {
        type = lib.types.port;
        default = 8080;
        description = "A port where leaps listens for incoming http requests";
      };
      address = lib.mkOption {
        default = "";
        type = lib.types.str;
        example = "127.0.0.1";
        description = "Hostname or IP-address to listen to. By default it will listen on all interfaces.";
      };
      path = lib.mkOption {
        default = "/";
        type = lib.types.path;
        description = "Subdirectory used for reverse proxy setups";
      };
    };
  };

  config = lib.mkIf cfg.enable {
    users = {
      users.leaps = {
        uid             = config.ids.uids.leaps;
        description     = "Leaps server user";
        group           = "leaps";
        home            = stateDir;
        createHome      = true;
      };

      groups.leaps = {
        gid = config.ids.gids.leaps;
      };
    };

    systemd.services.leaps = {
      description   = "leaps service";
      wantedBy      = [ "multi-user.target" ];
      after         = [ "network.target" ];

      serviceConfig = {
        User = "leaps";
        Group = "leaps";
        Restart = "on-failure";
        WorkingDirectory = stateDir;
        PrivateTmp = true;
        ExecStart = "${pkgs.leaps}/bin/leaps -path ${toString cfg.path} -address ${cfg.address}:${toString cfg.port}";
      };
    };
  };
}
