{ config, lib, pkgs, ... }:

let
  inherit (lib) mkIf mkOption singleton types;
  inherit (pkgs) coreutils exim;
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
        type = types.string;
        default = "";
        description = ''
          Verbatim Exim configuration.  This should not contain exim_user,
          exim_group, exim_path, or spool_directory.
        '';
      };

      user = mkOption {
        type = types.string;
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
        type = types.string;
        default = "exim";
        description = ''
          Group to use when no root privileges are required.
        '';
      };

      spoolDir = mkOption {
        type = types.string;
        default = "/var/spool/exim";
        description = ''
          Location of the spool directory of exim.
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
        exim_path = /var/setuid-wrappers/exim
        spool_directory = ${cfg.spoolDir}
        ${cfg.config}
      '';
      systemPackages = [ exim ];
    };

    users.extraUsers = singleton {
      name = cfg.user;
      description = "Exim mail transfer agent user";
      uid = config.ids.uids.exim;
      group = cfg.group;
    };

    users.extraGroups = singleton {
      name = cfg.group;
      gid = config.ids.gids.exim;
    };

    security.setuidPrograms = [ "exim" ];

    systemd.services.exim = {
      description = "Exim Mail Daemon";
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
        ExecStart   = "${exim}/bin/exim -bdf -q30m";
        ExecReload  = "${coreutils}/bin/kill -HUP $MAINPID";
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
