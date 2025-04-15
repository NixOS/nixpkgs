{ config, lib, ... }:

let
  cfg = config.networking.firewall;
in
{
  options.networking.firewall = {
    firewalld.enable = lib.mkEnableOption "the firewalld based firewall";
  };

  config = lib.mkIf (cfg.enable && cfg.firewalld.enable && config.networking.nftables.enable == false) {
    services.firewalld = {
      settings = {
        DefaultZone = "nixos-fw-default";
        LogDenied =
          if cfg.logRefusedConnections then
            (if cfg.logRefusedUnicastsOnly then "unicast" else "all")
          else
            "off";
      };
      zones = {
        nixos-fw-default = {
          target = if cfg.rejectPackets then "%%REJECT%%" else "DROP";
          ports =
            let
              f = protocol: port: { inherit protocol port; };
              tcpPorts = map (f "tcp") (cfg.allowedTCPPorts ++ cfg.allowedTCPPortRanges);
              udpPorts = map (f "udp") (cfg.allowedUDPPorts ++ cfg.allowedUDPPortRanges);
            in
            tcpPorts ++ udpPorts;
        };
        nixos-fw-trusted = {
          target = "ACCEPT";
          interfaces = cfg.trustedInterfaces;
        };
      };
    };
  };
}
