# Module for igmpproxy, a simple multicast router

{ config, lib, pkgs, ... }:
with lib;
let
  cfg = config.services.igmpproxy;
  confFile = pkgs.writeText "igmpproxy.conf" cfg.config;
in {
  options = {
    services.igmpproxy.enable = mkOption {
      type = types.bool;
      default = false;
      description =
        ''
          Whether to enable a simple multicast router
          (<command>igmpproxy</command>), which is able to route multicast
          across network interfaces using IGMP forwarding.

          If you experience issues with igmpproxy starting at boot, set
          <option>networking.dhcpcd.wait</option> to "both" to delay
          <literal>network-online.target</literal> from being reached early.
        '';
    };

    services.igmpproxy.config = mkOption {
      example =
        ''
          quickleave
          phyint eth0 upstream  ratelimit 0  threshold 1
            altnet 10.0.0.0/8
            altnet 192.168.0.0/24
          phyint eth1 downstream  ratelimit 0  threshold 1
          phyint eth2 disabled
        '';
      description =
        ''
          The contents of the igmpproxy configuration file.
        '';
    };
  };

  config = mkIf cfg.enable {
    systemd.services.igmpproxy = {
      description = "igmpproxy Multicast Router Daemon";
      wantedBy = [ "multi-user.target" ];
      after = [ "network-online.target" ];
      serviceConfig = {
        ExecStart = "@${pkgs.igmpproxy}/bin/igmpproxy igmpproxy -n ${confFile}";
        Restart = "always";
        # The software has a built in check for being root.  Exploring if
        # it can be run as another user with ambient capabilities would
        # be nice.
        User = "root";
        CapabilityBoundingSet = "cap_net_admin cap_net_broadcast cap_net_raw";
      };
    };
  };

  meta = {
    maintainers = with lib.maintainers; [ sdier ];
  };
}
