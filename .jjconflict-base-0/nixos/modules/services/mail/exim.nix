{ config, lib, pkgs, ... }:

let
  inherit (lib) literalExpression mkIf mkOption singleton types mkPackageOption;
  inherit (pkgs) coreutils;
  cfg = config.services.exim;
in

{

  ###### interface

  options = {

    services.exim = {

      enable = mkOption {
        type = types.bool;
        default = false;
        description = "Whether to enable the Exim mail transfer agent.";
      };

      config = mkOption {
        type = types.lines;
        default = "";
        description = ''
          Verbatim Exim configuration.  This should not contain exim_user,
          exim_group, exim_path, or spool_directory.
        '';
      };

      user = mkOption {
        type = types.str;
        default = "exim";
        description = ''
          User to use when no root privileges are required.
          In particular, this applies when receiving messages and when doing
          remote deliveries.  (Local deliveries run as various non-root users,
          typically as the owner of a local mailbox.) Specifying this value
          as root is not supported.
        '';
      };

      group = mkOption {
        type = types.str;
        default = "exim";
        description = ''
          Group to use when no root privileges are required.
        '';
      };

      spoolDir = mkOption {
        type = types.path;
        default = "/var/spool/exim";
        description = ''
          Location of the spool directory of exim.
        '';
      };

      package = mkPackageOption pkgs "exim" {
        extraDescription = ''
          This can be used to enable features such as LDAP or PAM support.
        '';
      };

      queueRunnerInterval = mkOption {
        type = types.str;
        default = "5m";
        description = ''
          How often to spawn a new queue runner.
        '';
      };
    };

  };


  ###### implementation

  config = mkIf cfg.enable {

    environment = {
      etc."exim.conf".text = ''
        exim_user = ${cfg.user}
        exim_group = ${cfg.group}
        exim_path = /run/wrappers/bin/exim
        spool_directory = ${cfg.spoolDir}
        ${cfg.config}
      '';
      systemPackages = [ cfg.package ];
    };

    users.users.${cfg.user} = {
      description = "Exim mail transfer agent user";
      uid = config.ids.uids.exim;
      group = cfg.group;
    };

    users.groups.${cfg.group} = {
      gid = config.ids.gids.exim;
    };

    security.wrappers.exim =
      { setuid = true;
        owner = "root";
        group = "root";
        source = "${cfg.package}/bin/exim";
      };

    systemd.services.exim = {
      description = "Exim Mail Daemon";
      wantedBy = [ "multi-user.target" ];
      restartTriggers = [ config.environment.etc."exim.conf".source ];
      serviceConfig = {
        ExecStart   = "!${cfg.package}/bin/exim -bdf -q${cfg.queueRunnerInterval}";
        ExecReload  = "!${coreutils}/bin/kill -HUP $MAINPID";
        User        = cfg.user;
      };
      preStart = ''
        if ! test -d ${cfg.spoolDir}; then
          ${coreutils}/bin/mkdir -p ${cfg.spoolDir}
          ${coreutils}/bin/chown ${cfg.user}:${cfg.group} ${cfg.spoolDir}
        fi
      '';
    };

  };

}
