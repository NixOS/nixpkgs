#!/usr/bin/env bash

set -euo pipefail

# Detect if iptables or nftables-based firewall is used.
if [[ -e /etc/systemd/system/firewall.service ]]; then
    BACKEND=iptables
elif [[ -e /etc/systemd/system/nftables.service ]]; then
    BACKEND=nftables
else
    echo "nixos-firewall-tool: cannot detect firewall backend" >&2
    exit 1
fi

ip46tables() {
  iptables -w "$@"
  ip6tables -w "$@"
}

show_help() {
    echo "nixos-firewall-tool"
    echo ""
    echo "Can temporarily manipulate the NixOS firewall"
    echo ""
    echo "Open TCP port:"
    echo " nixos-firewall-tool open tcp 8888"
    echo ""
    echo "Show all firewall rules:"
    echo " nixos-firewall-tool show"
    echo ""
    echo "Open UDP port:"
    echo " nixos-firewall-tool open udp 51820"
    echo ""
    echo "Reset firewall configuration to system settings:"
    echo " nixos-firewall-tool reset"
}

if [[ -z ${1+x} ]]; then
  show_help
  exit 1
fi

case $1 in
  "open")
    protocol="$2"
    port="$3"

    case $BACKEND in
        iptables)
            ip46tables -I nixos-fw -p "$protocol" --dport "$port" -j nixos-fw-accept
            ;;
        nftables)
            nft add element inet nixos-fw "temp-ports" "{ $protocol . $port }"
            ;;
    esac
  ;;
  "show")
    case $BACKEND in
        iptables)
            ip46tables --numeric --list nixos-fw
            ;;
        nftables)
            nft list table inet nixos-fw
            ;;
    esac
  ;;
  "reset")
    case $BACKEND in
        iptables)
            systemctl restart firewall.service
            ;;
        nftables)
            nft flush set inet nixos-fw "temp-ports"
            ;;
    esac
  ;;
  -h|--help|help)
    show_help
    exit 0
  ;;
  *)
    show_help
    exit 1
  ;;
esac
