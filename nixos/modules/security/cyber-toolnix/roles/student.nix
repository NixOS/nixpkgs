{ pkgs, ... }:

with pkgs;

[
  aircrack-ng
  binwalk
  burpsuite
  caido
  cewl
  crunch
  dirb
  dnsmasq
  edb
  enum4linux
  enum4linux-ng
  # https://github.com/NixOS/nixpkgs/issues/340969
  # evil-winrm
  exploitdb
  ffuf
  fierce
  ghidra
  gobuster
  hashcat
  hashcat-utils
  hcxtools
  john
  kismet
  medusa
  metasploit
  mitmproxy
  nasm
  nikto
  nmap
  proxychains-ng
  pwncat
  python312Packages.pypykatz
  radare2
  responder
  social-engineer-toolkit
  sqlmap
  thc-hydra
  theharvester
  wafw00f
  # https://github.com/NixOS/nixpkgs/issues/326902
  # wfuzz
  wifite2
  wireshark
  wpscan
  ### payloads and wordlists
  payloadsallthethings
  seclists
]
