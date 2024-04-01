{ config, pkgs, lib, ... }:

with lib;

let
  cfg = config.services.leaps;
  stateDir = "/var/lib/leaps/";
in
{
  options = {
    services.leaps = {
      enable = mkEnableOption "leaps";
      port = mkOption {
        type = types.port;
        default = 8080;
        description = lib.mdDoc "A port where leaps listens for incoming http requests";
      };
      address = mkOption {
        default = "";
        type = types.str;
        example = "127.0.0.1";
        description = lib.mdDoc "Hostname or IP-address to listen to. By default it will listen on all interfaces.";
      };
      path = mkOption {
        default = "/";
        type = types.path;
        description = lib.mdDoc "Subdirectory used for reverse proxy setups";
      };
    };
  };

  config = mkIf cfg.enable {
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
