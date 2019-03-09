{ config, lib, pkgs, ... }:

with lib;

let

  cfg = config.services.munge;

in

{

  ###### interface

  options = {

    services.munge = {
      enable = mkEnableOption "munge service";

      password = mkOption {
        default = "/etc/munge/munge.key";
        type = types.string;
        description = ''
          The path to a daemon's secret key.
        '';
      };

    };

  };

  ###### implementation

  config = mkIf cfg.enable {

    environment.systemPackages = [ pkgs.munge ];

    users.users.munge = {
      description   = "Munge daemon user";
      isSystemUser  = true;
      group         = "munge";
    };

    users.groups.munge = {};

    systemd.services.munged = {
      wantedBy = [ "multi-user.target" ];
      after = [ "network.target" ];

      path = [ pkgs.munge pkgs.coreutils ];

      preStart = ''
        chmod 0400 ${cfg.password}
        mkdir -p /var/lib/munge -m 0711
        chown -R munge:munge /var/lib/munge
        mkdir -p /run/munge -m 0755
        chown -R munge:munge /run/munge
      '';

      serviceConfig = {
        ExecStart = "${pkgs.munge}/bin/munged --syslog --key-file ${cfg.password}";
        PIDFile = "/run/munge/munged.pid";
        ExecReload = "${pkgs.coreutils}/bin/kill -HUP $MAINPID";
        PermissionsStartOnly = "true";
        User = "munge";
        Group = "munge";
      };

    };

  };

}
