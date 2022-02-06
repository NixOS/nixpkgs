{ config, pkgs, lib, ... }:

{
  options = {
    services.v2raya = {
      enable = lib.options.mkEnableOption "the v2rayA service";
    };
  };

  config = lib.mkIf config.services.v2raya.enable {
    systemd.services.v2raya = {
      unitConfig = {
        Description = "v2rayA service";
        Documentation = "https://github.com/v2rayA/v2rayA/wiki";
        After = [ "network.target" "nss-lookup.target" "iptables.service" "ip6tables.service" ];
        Wants = [ "network.target" ];
      };

      serviceConfig = {
        User = "root";
        ExecStart = "${pkgs.v2raya}/bin/v2rayA --log-disable-timestamp";
        LimitNPROC = 500;
        LimitNOFILE = 1000000;
        Restart = "on-failure";
        Type = "simple";
      };

      wantedBy = [ "multi-user.target" ];
      path = with pkgs; [ iptables bash iproute2 ]; # required by v2rayA TProxy functionality
    };
  };
}
