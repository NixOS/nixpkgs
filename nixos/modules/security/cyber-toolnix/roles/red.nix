{ pkgs, ... }:

with pkgs;

[
  # _3proxy
  # ad-miner # To be backported to 24.05
  # https://github.com/NixOS/nixpkgs/issues/326942
  # adenum
  aesfix
  aeskeyfind
  aflplusplus
  afpfs-ng
  aiodnsbrute
  amass
  apache-users
  apachetomcatscanner
  # archivebox https://github.com/NixOS/nixpkgs/issues/276947
  ares-rs
  argus
  argus-clients
  arjun
  arp-scan
  arpoison
  asleap
  asnmap
  assetfinder
  atftp
  bettercap
  bind
  bkcrack
  bloodhound
  bloodhound-py
  boofuzz
  braa
  brakeman
  bruteforce-luks
  brutespray
  bully
  burpsuite
  cadaver
  caido
  # cameradar
  cantoolz
  certgraph
  certipy
  certsync
  cewl
  cfr
  chainsaw
  chaos
  checksec
  chipsec
  chntpw
  clair
  clairvoyance
  cloudlist
  cmospwd
  coercer
  commix
  corkscrew
  cowpatty
  crackle
  crackmapexec
  crackql
  creds
  crlfuzz
  crowbar
  ctypes_sh
  # https://github.com/NixOS/nixpkgs/issues/308262
  # cutter
  # cutterPlugins.rz-ghidra
  dalfox
  darkstat
  davtest
  dirb
  dirstalk
  dive
  dnsenum
  dnsmasq
  dnsrecon
  dnstracer
  dnstwist
  dnsx
  dontgo403
  doona
  dorkscout
  driftnet
  dsniff
  # dublin-traceroute # To be backported to 24.05
  dump1090
  edb
  enum4linux
  enum4linux-ng
  eresi
  etherape
  ettercap
  evillimiter
  # https://github.com/NixOS/nixpkgs/issues/340969
  # evil-winrm
  exabgp
  exploitdb
  fcrackzip
  feroxbuster
  ffuf
  fierce
  findomain
  firewalk
  flasm
  fping
  freeipmi
  freerdp
  fscan
  gau
  gdb
  gdbgui
  geoip
  ghauri
  ghdorker
  ghidra
  girsh
  # git-hound # Marked as broken
  gitleaks
  go-cve-search
  gobuster
  gomapenum
  gospider
  gowitness
  gpredict
  graphinder
  graphqlmap
  graphw00f
  grype
  gsocket
  haka
  hakrawler
  hashcat
  hashcat-utils
  hashpump
  hcxdumptool
  hcxtools
  holehe
  honggfuzz
  hopper
  hping
  httping
  httprobe
  httpx
  hyenae
  i2pd
  iaito
  ike-scan
  interactsh
  ipmitool
  iputils
  jadx
  jaeles
  # https://github.com/NixOS/nixpkgs/issues/308260
  # jd-cli
  jd-gui
  jnetmap
  john
  johnny
  joomscan
  jpexs
  jsbeautifier
  junkie
  jwt-hack
  kalibrate-rtl
  katana
  kerbrute
  kismet
  kiterunner
  # https://github.com/NixOS/nixpkgs/issues/326927
  # klee
  knockpy
  kube-hunter
  ldapdomaindump
  ldeep
  libargon2
  libpst
  libtins
  ligolo-ng
  linux-exploit-suggester
  lldb
  log4j-scan
  lynis
  macchanger
  # pyhanko error on maigret
  # maigret
  mailsend
  maltego
  mapcidr
  masscan
  mdk4
  medusa
  metabigor
  metasploit
  mfoc
  mitm6
  mitmproxy
  mitmproxy2swagger
  mongoaudit
  monsoon
  mtr
  mtr-gui
  naabu
  nbtscanner
  ncrack
  netdiscover
  netmask
  netsniff-ng
  networkminer
  nfdump
  ngrep
  ngrok
  nikto
  nmap
  nosqli
  ntlmrecon
  nuclei
  obfs4
  onesixtyone
  osslsigncode
  ostinato
  p0f
  padbuster
  parsero
  pcapfix
  pdfcrack
  pe-bear
  photon
  phrasendrescher
  pixiewps
  plecost
  powersploit
  pmacct
  procyon
  proxmark3
  psudohash
  pwnat
  pwncat
  # capstone-5.0.1 not supported for interpreter python3.12
  python311Packages.angrop
  python312Packages.arsenic
  python312Packages.dnspython
  python312Packages.httpx
  python312Packages.impacket
  python312Packages.ldapdomaindump
  python312Packages.minidump
  python312Packages.minikerberos
  python312Packages.myjwt
  python312Packages.netmap
  # nose-1.3.7 not supported for interpreter python3.12
  python311Packages.patator
  python312Packages.pyjsparser
  python312Packages.pypykatz
  python312Packages.rfcat
  # capstone-5.0.1 not supported for interpreter python3.12
  python311Packages.ropgadget
  # capstone-5.0.1 not supported for interpreter python3.12
  python311Packages.ropper
  python312Packages.scapy
  # https://github.com/NixOS/nixpkgs/issues/308235
  # python312Packages.scrapy
  # https://github.com/NixOS/nixpkgs/issues/308232
  # python312Packages.scrapy-deltafetch
  # python312Packages.scrapy-fake-useragent
  # python312Packages.scrapy-splash
  python312Packages.shodan
  python312Packages.spyse-python
  python312Packages.sshtunnel
  python312Packages.thefuzz
  python312Packages.torpy
  # python312Packages.uncompyle6
  python312Packages.websockify
  radamsa
  radare2
  rarcrack
  rathole
  reaverwps-t6x
  redfang
  redsocks
  responder
  retdec
  rinetd
  # rita # To be backported to 24.05
  rizin
  rizinPlugins.rz-ghidra
  ropgadget
  # https://github.com/NixOS/nixpkgs/issues/326970
  # routersploit
  ruler
  rustcat
  rustscan
  saleae-logic
  saleae-logic-2
  samplicator
  seclists
  shellnoob
  sherlock
  sipvicious
  slither-analyzer
  smbmap
  snallygaster
  sniffglue
  snmpcheck
  snort
  snowman
  # https://github.com/NixOS/nixpkgs/issues/326940
  # snscrape
  snyk
  soapui
  socat
  social-engineer-toolkit
  socialscan
  spiped
  sqlmap
  ssh-audit
  ssh-mitm
  sshocker
  sshuttle
  ssldump
  sslh
  sslscan
  sslsplit
  stacs
  stunnel
  subfinder
  subjs
  swaks
  # swftools
  # https://github.com/NixOS/nixpkgs/pull/326600
  # sysdig
  tcpdump
  tcpflow
  tcpreplay
  tcptraceroute
  testssl
  tfsec
  thc-hydra
  thc-ipv6
  theharvester
  tinc
  tlsx
  tor
  traceroute
  # trinity
  trivy
  trufflehog
  udp2raw
  udptunnel
  uncover
  vivisect
  wafw00f
  wapiti
  webanalyze
  websploit
  # https://github.com/NixOS/nixpkgs/issues/326902
  # wfuzz
  whatweb
  wifite2
  wireshark
  wpscan
  wuzz
  xcat
  # https://github.com/NixOS/nixpkgs/issues/326943
  # xsser
  yersinia
  zap
  zdns
  zeek
  zgrab2
  zmap
  zssh
  zulu
  zzuf
  ### payloads and wordlists
  payloadsallthethings
  seclists
]
