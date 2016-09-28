{ config, lib, pkgs, ... }:

with lib;

let

  cfg = config.networking.fan;
  modprobe = "${pkgs.kmod}/bin/modprobe";

in

{

  ###### interface

  options = {

    networking.fan = {

      enable = mkEnableOption "FAN Networking";

    };

  };


  ###### implementation

  config = mkIf cfg.enable {

    environment.systemPackages = [ pkgs.fanctl ];

    systemd.services.fan = {
      description = "FAN Networking";
      wantedBy = [ "multi-user.target" ];
      after = [ "network-online.target" ];
      before = [ "docker.service" ];
      restartIfChanged = false;
      preStart = ''
        if [ ! -f /proc/sys/net/fan/version ]; then
          ${modprobe} ipip
          if [ ! -f /proc/sys/net/fan/version ]; then
            echo "The Fan Networking patches have not been applied to this kernel!" 1>&2
            exit 1
          fi
        fi

        mkdir -p /var/lib/fan-networking
      '';
      serviceConfig = {
        Type = "oneshot";
        RemainAfterExit = true;
        ExecStart = "${pkgs.fanctl}/bin/fanctl up -a";
        ExecStop = "${pkgs.fanctl}/bin/fanctl down -a";
      };
    };

  };

}
