{ config, pkgs, lib, ... }:

with lib;

{
  options = {
    services.v2raya = {
      enable = options.mkEnableOption "the v2rayA service";
    };
  };

  config = mkIf config.services.v2raya.enable {
    environment.systemPackages = [ pkgs.v2raya ];

    systemd.services.v2raya =
      let
        nftablesEnabled = config.networking.nftables.enable;
        iptablesServices = [
          "iptables.service"
        ] ++ optional config.networking.enableIPv6 "ip6tables.service";
        tableServices = if nftablesEnabled then [ "nftables.service" ] else iptablesServices;
      in
      {
        unitConfig = {
          Description = "v2rayA service";
          Documentation = "https://github.com/v2rayA/v2rayA/wiki";
          After = [
            "network.target"
            "nss-lookup.target"
          ] ++ tableServices;
          Wants = [ "network.target" ];
        };

        serviceConfig = {
          User = "root";
          ExecStart = "${getExe pkgs.v2raya} --log-disable-timestamp";
          Environment = [ "V2RAYA_LOG_FILE=/var/log/v2raya/v2raya.log" ];
          LimitNPROC = 500;
          LimitNOFILE = 1000000;
          Restart = "on-failure";
          Type = "simple";
        };

        wantedBy = [ "multi-user.target" ];
        path = with pkgs; [ iptables bash iproute2 ] ++ lib.optionals nftablesEnabled [ nftables ]; # required by v2rayA TProxy functionality
      };
  };

  meta.maintainers = with maintainers; [ elliot ];
}
