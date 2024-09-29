{ pkgs, ... }:

with pkgs;

[
  amass
  arjun
  assetfinder
  burpsuite
  caido
  cewl
  chaos
  commix
  crlfuzz
  crunch
  dalfox
  detect-secrets
  dirb
  dirstalk
  dnsx
  exploitdb
  feroxbuster
  ffuf
  findomain
  gau
  gitleaks
  gobuster
  gospider
  gowitness
  graphqlmap
  hakrawler
  httpx
  jaeles
  joomscan
  jwt-hack
  knockpy
  masscan
  metasploit
  naabu
  nikto
  nmap
  nosqli
  nuclei
  psudohash
  pwncat
  python312Packages.httpx
  # nose-1.3.7 not supported for interpreter python3.12
  python311Packages.patator
  rustscan
  sqlmap
  subfinder
  thc-hydra
  theharvester
  trufflehog
  wafw00f
  webanalyze
  # https://github.com/NixOS/nixpkgs/issues/326902
  # wfuzz
  whatweb
  whispers
  wpscan
  # https://github.com/NixOS/nixpkgs/issues/326943
  # xsser
  ### payloads and wordlists
  payloadsallthethings
  seclists
]
