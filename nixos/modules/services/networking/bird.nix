{ config, lib, pkgs, ... }:

let
  inherit (lib) mkEnableOption mkIf mkOption singleton types;
  inherit (pkgs) bird;
  cfg = config.services.bird;
  cfg6 = config.services.bird6;

  configFile = name: conf: pkgs.writeText "${name}.conf" ''
    ${conf}
  '';

  mkOptions = name: pkg: {
    enable = mkEnableOption "${name} Internet Routing Daemon";

    config = mkOption {
      type = types.string;
      description = ''
        ${name} Internet Routing Daemon configuration file.
        <link xlink:href='http://bird.network.cz/'/>
      '';
    };

    package = mkOption {
      type = types.package;
      default = pkg;
      description = ''
        BIRD package to use.
      '';
    };

    user = mkOption {
      type = types.string;
      default = "bird";
      description = ''
        ${name} Internet Routing Daemon user.
      '';
    };

    group = mkOption {
      type = types.string;
      default = "bird";
      description = ''
        ${name} Internet Routing Daemon group.
      '';
    };
  };

  mkService = name: cfg: {
    description = "${name} Internet Routing Daemon";
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      ExecStart = "${cfg.package}/bin/${name} -d -c ${configFile name cfg.config} -s /var/run/${name}.ctl -u ${cfg.user} -g ${cfg.group}";
    };
  };

in

{

  ###### interface

  options = {

    services.bird = mkOptions "bird" pkgs.bird;

    services.bird6 = mkOptions "bird6" pkgs.bird6;

  };


  ###### implementation

  config = mkIf (cfg.enable || cfg6.enable) {

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

    systemd.services.bird = mkIf cfg.enable (mkService "bird" cfg);
    systemd.services.bird6 = mkIf cfg6.enable (mkService "bird6" cfg6);
  };
}
