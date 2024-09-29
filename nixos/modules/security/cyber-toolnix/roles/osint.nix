{ pkgs, ... }:

with pkgs;

[
  ad-miner # To be backported to 24.05
  aiodnsbrute
  amass
  asn
  assetfinder
  bind
  bloodhound
  bloodhound-py
  cantoolz
  certgraph
  chaos
  checkpwn
  clairvoyance
  cloudlist
  dnsenum
  dnsrecon
  dnstracer
  dnstwist
  dnsx
  dorkscout
  enum4linux
  enum4linux-ng
  fierce
  findomain
  fping
  gau
  geoip
  ghdorker
  git-hound # To be backported https://github.com/NixOS/nixpkgs/issues/276787
  gitleaks
  gomapenum
  gowitness
  graphinder
  holehe
  httping
  katana
  kiterunner
  knockpy
  ldeep
  linux-exploit-suggester
  # pyhanko error on maigret
  # maigret
  maltego
  metabigor
  metasploit
  netdiscover
  netmask
  ntlmrecon
  octosuite
  parsero
  photon
  proxmark3
  python312Packages.shodan
  # https://github.com/NixOS/nixpkgs/issues/308235
  # python312Packages.scrapy
  # https://github.com/NixOS/nixpkgs/issues/308232
  # python312Packages.scrapy-deltafetch
  # python312Packages.scrapy-fake-useragent
  # python312Packages.scrapy-splash
  python312Packages.spyse-python
  rita
  sherlock
  sleuthkit
  smbmap
  sn0int
  sniffglue
  snmpcheck
  # https://github.com/NixOS/nixpkgs/issues/326940
  # snscrape
  social-engineer-toolkit
  socialscan
  subfinder
  subjs
  thc-ipv6
  theharvester
  traceroute
  trufflehog
  uncover
  webanalyze
  websploit
  whatweb
  zgrab2
]
