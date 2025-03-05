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
        type = types.path;
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
      wants = [
        "network-online.target"
        "time-sync.target"
      ];
      after = [
        "network-online.target"
        "time-sync.target"
      ];

      path = [ pkgs.munge pkgs.coreutils ];

      serviceConfig = {
        ExecStartPre = "+${pkgs.coreutils}/bin/chmod 0400 ${cfg.password}";
        ExecStart = "${pkgs.munge}/bin/munged --foreground --key-file ${cfg.password}";
        User = "munge";
        Group = "munge";
        StateDirectory = "munge";
        StateDirectoryMode = "0711";
        Restart = "on-failure";
        RuntimeDirectory = "munge";
      };

    };

  };

}
