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

      serviceConfig = {
        ExecStartPre = "+${pkgs.coreutils}/bin/chmod 0400 ${cfg.password}";
        ExecStart = "${pkgs.munge}/bin/munged --syslog --key-file ${cfg.password}";
        PIDFile = "/run/munge/munged.pid";
        ExecReload = "${pkgs.coreutils}/bin/kill -HUP $MAINPID";
        User = "munge";
        Group = "munge";
        StateDirectory = "munge";
        StateDirectoryMode = "0711";
        RuntimeDirectory = "munge";
      };

    };

  };

}
