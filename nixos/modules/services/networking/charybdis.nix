{ config, lib, pkgs, ... }:

let
  inherit (lib) mkEnableOption mkIf mkOption singleton types;
  inherit (pkgs) coreutils;
  cfg = config.services.charybdis;

  pkg = cfg.package;

  configFile = pkgs.writeText "charybdis.conf" ''
    ${cfg.config}
  '';
in

{

  ###### interface

  options = {

    services.charybdis = {

      enable = mkEnableOption "Charybdis IRC daemon";

      package = mkOption {
        default = pkgs.charybdis;
        type = types.package;
        description = ''
          Charybdis package to use.
        '';
      };

      config = mkOption {
        type = types.string;
        description = ''
          Charybdis IRC daemon configuration file.
        '';
      };

      statedir = mkOption {
        type = types.string;
        default = "/var/lib/charybdis";
        description = ''
          Location of the state directory of charybdis.
        '';
      };

      user = mkOption {
        type = types.string;
        default = "ircd";
        description = ''
          Charybdis IRC daemon user.
        '';
      };

      group = mkOption {
        type = types.string;
        default = "ircd";
        description = ''
          Charybdis IRC daemon group.
        '';
      };

    };

  };


  ###### implementation

  config = mkIf cfg.enable {

    users.extraUsers = singleton {
      name = cfg.user;
      description = "Charybdis IRC daemon user";
      uid = config.ids.uids.ircd;
      group = cfg.group;
    };

    users.extraGroups = singleton {
      name = cfg.group;
      gid = config.ids.gids.ircd;
    };

    systemd.services.charybdis = {
      description = "Charybdis IRC daemon";
      wantedBy = [ "multi-user.target" ];
      environment = {
        BANDB_DBPATH = "${cfg.statedir}/ban.db";
      };
      serviceConfig = {
        ExecStart   = "${pkg}/bin/charybdis-ircd -foreground -logfile /dev/stdout";
        Group = cfg.group;
        User = cfg.user;
        PermissionsStartOnly = true; # preStart needs to run with root permissions
      };
      restartIfChanged = false;
      preStart = ''
        ${coreutils}/bin/mkdir -p ${cfg.statedir}
        ${coreutils}/bin/chown ${cfg.user}:${cfg.group} ${cfg.statedir}
      '';

    };

  };

}
