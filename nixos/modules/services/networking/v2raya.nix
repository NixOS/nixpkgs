{ config, pkgs, lib, ... }:

with lib;

let
  cfg = config.services.v2raya;
in

{
  options = {
    services.v2raya = {
      enable = options.mkEnableOption "the v2rayA service";

      package = options.mkPackageOption pkgs "v2raya" { };
      cliPackage = options.mkOption {
        type = types.package;
        default = pkgs.v2ray;
        defaultText = literalExpression "pkgs.v2ray";
        example = literalExpression "pkgs.xray";
        description = ''
          The package used for the cli binary.
        '';
        relatedPackages = [ "xray" "v2ray" ];
      };
    };
  };

  config = mkIf config.services.v2raya.enable {
    environment.systemPackages = [ (pkgs.v2raya.override { v2ray = cfg.cliPackage; }) ];

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
          ExecStart = "${getExe (pkgs.v2raya.override { v2ray = cfg.cliPackage; })} --log-disable-timestamp";
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

