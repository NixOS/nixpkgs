{ config, lib, pkgs, ... }:

let
  inherit (lib) mkEnableOption mkIf mkOption singleton types;
  inherit (pkgs) coreutils charybdis;
  cfg = config.services.charybdis;

  configFile = pkgs.writeText "charybdis.conf" ''
    ${cfg.config}
  '';
in

{

  ###### interface

  options = {

    services.charybdis = {

      enable = mkEnableOption "Charybdis IRC daemon";

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

      motd = mkOption {
        type = types.nullOr types.lines;
        default = null;
        description = ''
          Charybdis MOTD text.

          Charybdis will read its MOTD from /etc/charybdis/ircd.motd .
          If set, the value of this option will be written to this path.
        '';
      };

    };

  };


  ###### implementation

  config = mkIf cfg.enable (lib.mkMerge [
    {
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
          ExecStart   = "${charybdis}/bin/charybdis-ircd -foreground -logfile /dev/stdout -configfile ${configFile}";
          Group = cfg.group;
          User = cfg.user;
          PermissionsStartOnly = true; # preStart needs to run with root permissions
        };
        preStart = ''
          ${coreutils}/bin/mkdir -p ${cfg.statedir}
          ${coreutils}/bin/chown ${cfg.user}:${cfg.group} ${cfg.statedir}
        '';
      };

    }
    
    (mkIf (cfg.motd != null) {
      environment.etc."charybdis/ircd.motd".text = cfg.motd;
    })
  ]);
}
