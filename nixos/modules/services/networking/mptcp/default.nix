{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.networking.mptcp;

  mptcpUp = ./mptcp_up_raw;
in
{
  options.networking.mptcp = {

    enable = mkEnableOption "Multipath TCP (MPTCP)";

    debug = mkEnableOption "Debug support";

    package = mkOption {
      type = types.package;
      default = pkgs.linux_mptcp;
      defaultText = "pkgs.linux_mptcp";
      description = ''
        Default MPTCP kernel to use.
      '';
    };

    scheduler = mkOption {
      type = types.enum [ "redundant" "lowrtt" "roundrobin" "default" ];
      default = "lowrtt";
      description = ''
        How to schedule packets on the different subflows.
      '';
    };

    pathManager = mkOption {
      type = types.enum [ "fullmesh" "ndiffports" "netlink" ];
      default = "fullmesh";
      description = ''
        Subflow creation strategy.
        Netlink is only available in the development version of mptcp.
      '';
    };
  };

  config = lib.mkIf cfg.enable (mkMerge [
    {
      # to name routing tables
      networking.iproute2.enable = true;

      boot.kernelPackages = pkgs.linuxPackagesFor cfg.package;

      boot.kernel.sysctl = {
        "net.mptcp.mptcp_scheduler" = cfg.scheduler;
        "net.mptcp.mptcp_path_manager" = cfg.pathManager;
        "net.ipv4.tcp_congestion_control" = "olia";
      };
    }

    (mkIf (!config.networking.networkmanager.enable) {
      warnings = [
        "You have `networkmanager` disabled. MPTCP may not be able to use all interfaces."
      ];
    })

    # if networkmanager is enabled, handle routing tables
    (mkIf config.networking.networkmanager.enable {
      networking.networkmanager.dispatcherScripts = [
          { source = mptcpUp; type = "basic"; }
        ];
     })

   ]);
}
