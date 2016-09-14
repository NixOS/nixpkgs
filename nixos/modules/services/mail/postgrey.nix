{ config, lib, pkgs, ... }:

with lib; let

  cfg = config.services.postgrey;

in {

  options = {
    services.postgrey = with types; {
      enable = mkOption {
        type = bool;
        default = false;
        description = "Whether to run the Postgrey daemon";
      };
      inetAddr = mkOption {
        type = nullOr string;
        default = null;
        example = "127.0.0.1";
        description = "The inet address to bind to. If none given, bind to /var/run/postgrey.sock";
      };
      inetPort = mkOption {
        type = int;
        default = 10030;
        description = "The tcp port to bind to";
      };
      greylistText = mkOption {
        type = string;
        default = "Greylisted for %%s seconds";
        description = "Response status text for greylisted messages";
      };
    };
  };

  config = mkIf cfg.enable {

    environment.systemPackages = [ pkgs.postgrey ];

    users = {
      extraUsers = {
        postgrey = {
          description = "Postgrey Daemon";
          uid = config.ids.uids.postgrey;
          group = "postgrey";
        };
      };
      extraGroups = {
        postgrey = {
          gid = config.ids.gids.postgrey;
        };
      };
    };

    systemd.services.postgrey = let
      bind-flag = if isNull cfg.inetAddr then
        "--unix=/var/run/postgrey.sock"
      else
        "--inet=${cfg.inetAddr}:${cfg.inetPort}";
    in {
      description = "Postfix Greylisting Service";
      wantedBy = [ "multi-user.target" ];
      before = [ "postfix.service" ];
      preStart = ''
        mkdir -p /var/postgrey
        chown postgrey:postgrey /var/postgrey
        chmod 0770 /var/postgrey
      '';
      serviceConfig = {
        Type = "simple";
        ExecStart = ''${pkgs.postgrey}/bin/postgrey ${bind-flag} --pidfile=/var/run/postgrey.pid --group=postgrey --user=postgrey --dbdir=/var/postgrey --greylist-text="${cfg.greylistText}"'';
        Restart = "always";
        RestartSec = 5;
        TimeoutSec = 10;
      };
    };

  };

}
