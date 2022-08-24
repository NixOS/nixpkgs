{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.netbird;
  kernel = config.boot.kernelPackages;
  interfaceName = "wt0";
in {
  meta.maintainers = with maintainers; [ misuzu ];

  options.services.netbird = {
    enable = mkEnableOption "Netbird daemon";
    package = mkOption {
      type = types.package;
      default = pkgs.netbird;
      defaultText = literalExpression "pkgs.netbird";
      description = "The package to use for netbird";
    };
  };

  config = mkIf cfg.enable {
    boot.extraModulePackages = optional (versionOlder kernel.kernel.version "5.6") kernel.wireguard;

    environment.systemPackages = [ cfg.package ];

    networking.dhcpcd.denyInterfaces = [ interfaceName ];

    systemd.network.networks."50-netbird" = mkIf config.networking.useNetworkd {
      matchConfig = {
        Name = interfaceName;
      };
      linkConfig = {
        Unmanaged = true;
        ActivationPolicy = "manual";
      };
    };

    systemd.services.netbird = {
      description = "A WireGuard-based mesh network that connects your devices into a single private network";
      documentation = [ "https://netbird.io/docs/" ];
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
        AmbientCapabilities = [ "CAP_NET_ADMIN" ];
        DynamicUser = true;
        Environment = [
          "NB_CONFIG=/var/lib/netbird/config.json"
          "NB_LOG_FILE=console"
        ];
        ExecStart = "${cfg.package}/bin/netbird service run";
        Restart = "always";
        RuntimeDirectory = "netbird";
        StateDirectory = "netbird";
        WorkingDirectory = "/var/lib/netbird";
      };
      unitConfig = {
        StartLimitInterval = 5;
        StartLimitBurst = 10;
      };
      stopIfChanged = false;
    };
  };
}
