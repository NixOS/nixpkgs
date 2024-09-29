{ pkgs, ... }:

with pkgs;

[
  aflplusplus
  # archivebox # python-django dep is marked as insecure
  apachetomcatscanner
  arjun
  assetfinder
  boofuzz
  brakeman
  burpsuite
  caido
  cantoolz
  chipsec
  clairvoyance
  commix
  crackql
  crlfuzz
  dalfox
  dirb
  dirstalk
  dontgo403
  doona
  feroxbuster
  ffuf
  firewalk
  gau
  ghauri
  gobuster
  gospider
  gowitness
  graphinder
  graphqlmap
  graphw00f
  hakrawler
  honggfuzz
  httpx
  interactsh
  jaeles
  joomscan
  jsbeautifier
  jwt-hack
  katana
  kiterunner
  log4j-scan
  mdk4
  metasploit
  mitm6
  mitmproxy
  mitmproxy2swagger
  mongoaudit
  monsoon
  nikto
  nosqli
  nuclei
  photon
  plecost
  psudohash
  python312Packages.arsenic
  python312Packages.httpx
  python312Packages.pyjsparser
  # https://github.com/NixOS/nixpkgs/issues/308235
  # python312Packages.scrapy
  # https://github.com/NixOS/nixpkgs/issues/308232
  # python312Packages.scrapy-deltafetch
  # python312Packages.scrapy-fake-useragent
  # python312Packages.scrapy-splash
  python312Packages.thefuzz
  radamsa
  responder
  ruler
  snallygaster
  soapui
  sqlmap
  subjs
  # swftools
  # trinity
  wafw00f
  wapiti
  webanalyze
  websploit
  # https://github.com/NixOS/nixpkgs/issues/326902
  # wfuzz
  whatweb
  wpscan
  wuzz
  # https://github.com/NixOS/nixpkgs/issues/326943
  # xsser
  yersinia
  zap
  zzuf
  ### payloads and wordlists
  payloadsallthethings
  seclists
]
