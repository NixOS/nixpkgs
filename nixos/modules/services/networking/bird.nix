{ config, lib, pkgs, ... }:

let
  inherit (lib) mkEnableOption mkIf mkOption singleton types;
  inherit (pkgs) bird;
  cfg = config.services.bird;

  configFile = pkgs.writeText "bird.conf" ''
    ${cfg.config}
  '';
in

{

  ###### interface

  options = {

    services.bird = {

      enable = mkEnableOption "BIRD Internet Routing Daemon";

      config = mkOption {
        type = types.string;
        description = ''
          BIRD Internet Routing Daemon configuration file.
          <link xlink:href='http://bird.network.cz/'/>
        '';
      };

      user = mkOption {
        type = types.string;
        default = "bird";
        description = ''
          BIRD Internet Routing Daemon user.
        '';
      };

      group = mkOption {
        type = types.string;
        default = "bird";
        description = ''
          BIRD Internet Routing Daemon group.
        '';
      };

    };

  };


  ###### implementation

  config = mkIf cfg.enable {

    users.extraUsers = singleton {
      name = cfg.user;
      description = "BIRD Internet Routing Daemon user";
      uid = config.ids.uids.bird;
      group = cfg.group;
    };

    users.extraGroups = singleton {
      name = cfg.group;
      gid = config.ids.gids.bird;
    };

    systemd.services.bird = {
      description = "BIRD Internet Routing Daemon";
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
        ExecStart   = "${bird}/bin/bird -d -c ${configFile} -s /var/run/bird.ctl -u ${cfg.user} -g ${cfg.group}";
      };
    };
  };
}
