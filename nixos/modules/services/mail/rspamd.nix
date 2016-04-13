{ config, lib, pkgs, ... }:

with lib;

let

  cfg = config.services.rspamd;

in

{

  ###### interface

  options = {

    services.rspamd = {

      enable = mkOption {
        default = false;
        description = "Whether to run the rspamd daemon.";
      };

      debug = mkOption {
        default = false;
        description = "Whether to run the rspamd daemon in debug mode.";
      };

      user = mkOption {
        type = types.string;
        default = "rspamd";
        description = ''
          User to use when no root privileges are required.
        '';
       };

      group = mkOption {
        type = types.string;
        default = "rspamd";
        description = ''
          Group to use when no root privileges are required.
        '';
       };
    };

  };


  ###### implementation

  config = mkIf cfg.enable {

    # Allow users to run 'rspamc' and 'rspamadm'.
    environment.systemPackages = [ pkgs.rspamd ];

    users.extraUsers = singleton {
      name = cfg.user;
      description = "rspamd daemon";
      uid = config.ids.uids.rspamd;
      group = cfg.group;
    };

    users.extraGroups = singleton {
      name = cfg.group;
      gid = config.ids.gids.spamd;
    };

    systemd.services.rspamd = {
      description = "Rspamd Service";

      wantedBy = [ "multi-user.target" ];
      after = [ "network.target" ];

      serviceConfig = {
        ExecStart = "${pkgs.rspamd}/bin/rspamd ${optionalString cfg.debug "-d"} --user=${cfg.user} --group=${cfg.group} --pid=/run/rspamd.pid -f";
        RuntimeDirectory = "/var/lib/rspamd";
        PermissionsStartOnly = true;
        Restart = "always";
      };

      preStart = ''
        ${pkgs.coreutils}/bin/mkdir -p /var/{lib,log}/rspamd
        ${pkgs.coreutils}/bin/chown ${cfg.user}:${cfg.group} /var/lib/rspamd
      '';

    };

  };

}
