#!/usr/bin/env bash

set -euo pipefail

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

    ip46tables -I nixos-fw -p "$protocol" --dport "$port" -j nixos-fw-accept
  ;;
  "show")
    ip46tables --numeric --list nixos-fw
  ;;
  "reset")
    systemctl restart firewall.service
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
