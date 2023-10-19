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

      enable = mkEnableOption (lib.mdDoc "Charybdis IRC daemon");

      config = mkOption {
        type = types.str;
        description = lib.mdDoc ''
          Charybdis IRC daemon configuration file.
        '';
      };

      statedir = mkOption {
        type = types.path;
        default = "/var/lib/charybdis";
        description = lib.mdDoc ''
          Location of the state directory of charybdis.
        '';
      };

      user = mkOption {
        type = types.str;
        default = "ircd";
        description = lib.mdDoc ''
          Charybdis IRC daemon user.
        '';
      };

      group = mkOption {
        type = types.str;
        default = "ircd";
        description = lib.mdDoc ''
          Charybdis IRC daemon group.
        '';
      };

      motd = mkOption {
        type = types.nullOr types.lines;
        default = null;
        description = lib.mdDoc ''
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
      users.users.${cfg.user} = {
        description = "Charybdis IRC daemon user";
        uid = config.ids.uids.ircd;
        group = cfg.group;
      };

      users.groups.${cfg.group} = {
        gid = config.ids.gids.ircd;
      };

      systemd.tmpfiles.rules = [
        "d ${cfg.statedir} - ${cfg.user} ${cfg.group} - -"
      ];

      environment.etc."charybdis/ircd.conf".source = configFile;

      systemd.services.charybdis = {
        description = "Charybdis IRC daemon";
        wantedBy = [ "multi-user.target" ];
        reloadIfChanged = true;
        restartTriggers = [
          configFile
        ];
        environment = {
          BANDB_DBPATH = "${cfg.statedir}/ban.db";
        };
        serviceConfig = {
          ExecStart   = "${charybdis}/bin/charybdis -foreground -logfile /dev/stdout -configfile /etc/charybdis/ircd.conf";
          ExecReload = "${coreutils}/bin/kill -HUP $MAINPID";
          Group = cfg.group;
          User = cfg.user;
        };
      };

    }

    (mkIf (cfg.motd != null) {
      environment.etc."charybdis/ircd.motd".text = cfg.motd;
    })
  ]);
}
