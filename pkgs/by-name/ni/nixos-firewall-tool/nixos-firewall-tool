#!/usr/bin/env bash
# vim: set tabstop=2 shiftwidth=2 expandtab:

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
  echo "nixos-firewall-tool

A tool to temporarily manipulate the NixOS firewall

Open TCP port:
  nixos-firewall-tool open tcp 8888

Open UDP port:
  nixos-firewall-tool open udp 51820

Show all firewall rules:
  nixos-firewall-tool show

Reset firewall configuration to system settings:
  nixos-firewall-tool reset"
}

if [[ -z ${1+x} ]]; then
  show_help
  exit 1
fi

case $1 in
  "open")
    if [[ -z ${2+x} ]] || [[ -z ${3+x} ]]; then
      show_help
      exit 1
    fi

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
