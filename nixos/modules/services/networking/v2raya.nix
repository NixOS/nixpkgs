{ config, pkgs, lib, ... }:
{
  options = {
    services.v2raya = {
      enable = lib.mkEnableOption "the v2rayA service";
    };
  };

  config = lib.mkIf config.services.v2raya.enable {
    environment.systemPackages = [ pkgs.v2raya ];

    systemd.services.v2raya =
      let
        nftablesEnabled = config.networking.nftables.enable;
        iptablesServices = [
          "iptables.service"
        ] ++ lib.optional config.networking.enableIPv6 "ip6tables.service";
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
          ExecStart = "${lib.getExe pkgs.v2raya} --log-disable-timestamp";
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

  meta.maintainers = with lib.maintainers; [ elliot ];
}
