{ lib, pkgs, config, ... }:

with lib;

let

  buildVpnc = key: value: {
    name = "vpnc/${key}.conf";
    value = {
      text = ''
        IPSec gateway ${value.gateway}
        IPSec ID ${value.id}
        IPSec secret ${value.secret}
        Xauth username ${value.username}
        Password helper ${pkgs.systemd}/bin/systemd-ask-password
        Script ${pkgs.vpnc}/etc/vpnc/vpnc-script
        '';
    };
  };
  up = pkgs.writeScript "up" ''
    #!${pkgs.bash}/bin/bash
    PATH=${makeBinPath [pkgs.nettools pkgs.iproute]}:$PATH

    LOCAL_GATEWAY=$(ip r | grep "default via" | grep -oE "([0-9]+\.[0-9]+\.[0-9]+\.[0-9]+)" | head -n1)
    ip route del default via $LOCAL_GATEWAY
    ip route add default dev tun0 proto static scope link metric 50
    if [ ! -d /var/run/vpnc ]; then
      mkdir -p /var/run/vpnc
    fi
    echo -ne $LOCAL_GATEWAY > /var/run/vpnc/LOCAL_GATEWAY
  '';
  down = pkgs.writeScript "down" ''
    #!${pkgs.bash}/bin/bash
    PATH=${makeBinPath [pkgs.nettools pkgs.iproute]}:$PATH

    LOCAL_GATEWAY=$(cat /var/run/vpnc/LOCAL_GATEWAY)
    ip route add default via $LOCAL_GATEWAY
    ip route del default dev tun0
  '';
  buildService = key: value: nameValuePair "vpnc-${key}" {
    description = "VPNC for ${key}";
    # No automatic startup, password

    path = [ pkgs.iptables pkgs.nettools pkgs.iproute ];
    serviceConfig = {
      ExecStart = "${pkgs.vpnc}/bin/vpnc /etc/vpnc/${key}.conf";
      ExecStartPost = "${up}";
      ExecStopPost = "${down}";
      Type = "forking";
    };
  };

  cfg = config.services.networking.vpnc;
  vpnModule = types.submodule {
    options = {
      gateway = mkOption {
        default = "";
        type = types.separatedString "";
        description = "Gateway address";
      };
      id = mkOption {
        default = "linux";
        type = types.separatedString "";
        description = "Your group name";
      };
      secret = mkOption {
        default = "";
        type = types.separatedString "";
        description = "Your shared secret";
      };
      username = mkOption {
        default = "";
        type = types.separatedString "";
        description = "Your username";
        example = "john.doe@example.com";
      };
    };
  };

in

{
  options.services.networking.vpnc.servers = mkOption {
    default = {};

    description = "Each attribute defines a vpn client";

    type = types.attrsOf vpnModule;
  };

  config = mkIf (cfg.servers != {}) {
    environment.systemPackages = [ pkgs.vpnc ];
    boot.kernelModules = [ "tun" ];
    environment.etc = attrsets.mapAttrs' buildVpnc cfg.servers;
    systemd.services = listToAttrs (mapAttrsFlatten buildService cfg.servers);
  };
}
