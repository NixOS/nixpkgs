{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.miniupnpd;
  configFile = pkgs.writeText "miniupnpd.conf" ''
    ext_ifname=${cfg.externalInterface}
    enable_natpmp=${if cfg.natpmp then "yes" else "no"}
    enable_upnp=${if cfg.upnp then "yes" else "no"}

    ${concatMapStrings (range: ''
      listening_ip=${range}
    '') cfg.internalIPs}

    ${cfg.appendConfig}
  '';
in
{
  options = {
    services.miniupnpd = {
      enable = mkEnableOption "MiniUPnP daemon";

      externalInterface = mkOption {
        type = types.str;
        description = ''
          Name of the external interface.
        '';
      };

      internalIPs = mkOption {
        type = types.listOf types.str;
        example = [ "192.168.1.1/24" "enp1s0" ];
        description = ''
          The IP address ranges to listen on.
        '';
      };

      natpmp = mkEnableOption "NAT-PMP support";

      upnp = mkOption {
        default = true;
        type = types.bool;
        description = ''
          Whether to enable UPNP support.
        '';
      };

      appendConfig = mkOption {
        type = types.lines;
        default = "";
        description = ''
          Configuration lines appended to the MiniUPnP config.
        '';
      };
    };
  };

  config = mkIf cfg.enable {
    networking.firewall.extraCommands = ''
      ${pkgs.bash}/bin/bash -x ${pkgs.miniupnpd}/etc/miniupnpd/iptables_init.sh -i ${cfg.externalInterface}
    '';

    networking.firewall.extraStopCommands = ''
      ${pkgs.bash}/bin/bash -x ${pkgs.miniupnpd}/etc/miniupnpd/iptables_removeall.sh -i ${cfg.externalInterface}
    '';

    systemd.services.miniupnpd = {
      description = "MiniUPnP daemon";
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
        ExecStart = "${pkgs.miniupnpd}/bin/miniupnpd -f ${configFile}";
        PIDFile = "/run/miniupnpd.pid";
        Type = "forking";
      };
    };
  };
}
