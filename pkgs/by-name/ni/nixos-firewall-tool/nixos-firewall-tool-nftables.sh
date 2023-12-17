#!/usr/bin/env bash

set -euo pipefail

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

    nft add element inet nixos-fw "$protocol-ports" "{ $port }"
  ;;
  "show")
    nft list table inet nixos-fw
  ;;
  "reset")
    systemctl reload nftables.service
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
