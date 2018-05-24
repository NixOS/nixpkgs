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

    systemd.services.munged = {
      wantedBy = [ "multi-user.target" ];
      after = [ "network.target" ];

      path = with pkgs; [ munge coreutils ];

      preStart = ''
        chmod 0700 ${cfg.password}
      '';

      serviceConfig = {
        RuntimeDirectory = "munge";
        StateDirectory = "munge";
        LogDirectory = "munge";
        Type = "forking";
        ExecStart = "${pkgs.munge}/bin/munged --syslog --key-file ${cfg.password}";
        PIDFile = "/run/munge/munged.pid";
        ExecReload = "${pkgs.coreutils}/bin/kill -HUP $MAINPID";
      };

    };

  };

}
