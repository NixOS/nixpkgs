{
  config,
  lib,
  pkgs,
  ...
}:

let
  inherit (lib)
    mkEnableOption
    mkIf
    lib.mkOption
    singleton
    types
    ;
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

      enable = lib.mkEnableOption "Charybdis IRC daemon";

      config = lib.mkOption {
        type = lib.types.str;
        description = ''
          Charybdis IRC daemon configuration file.
        '';
      };

      statedir = lib.mkOption {
        type = lib.types.path;
        default = "/var/lib/charybdis";
        description = ''
          Location of the state directory of charybdis.
        '';
      };

      user = lib.mkOption {
        type = lib.types.str;
        default = "ircd";
        description = ''
          Charybdis IRC daemon user.
        '';
      };

      group = lib.mkOption {
        type = lib.types.str;
        default = "ircd";
        description = ''
          Charybdis IRC daemon group.
        '';
      };

      motd = lib.mkOption {
        type = lib.types.nullOr types.lines;
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

  config = lib.mkIf cfg.enable (
    lib.mkMerge [
      {
        users.users.${cfg.user} = {
          description = "Charybdis IRC daemon user";
          uid = config.ids.uids.ircd;
          group = cfg.group;
        };

        users.groups.${cfg.group} = {
          gid = config.ids.gids.ircd;
        };

        systemd.tmpfiles.settings."10-charybdis".${cfg.statedir}.d = {
          inherit (cfg) user group;
        };

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
            ExecStart = "${charybdis}/bin/charybdis -foreground -logfile /dev/stdout -configfile /etc/charybdis/ircd.conf";
            ExecReload = "${coreutils}/bin/kill -HUP $MAINPID";
            Group = cfg.group;
            User = cfg.user;
          };
        };

      }

      (lib.mkIf (cfg.motd != null) {
        environment.etc."charybdis/ircd.motd".text = cfg.motd;
      })
    ]
  );
}
