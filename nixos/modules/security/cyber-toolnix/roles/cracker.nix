{ pkgs, ... }:

with pkgs;

[
  aesfix
  aeskeyfind
  aespipe
  ares-rs
  asleap
  bkcrack
  bruteforce-luks
  brutespray
  bully
  cewl
  chntpw
  cmospwd
  cowpatty
  crackle
  crackql
  crowbar
  dislocker
  fcrackzip
  gnutls
  gomapenum
  hash_extender
  hash-identifier
  hashcat
  hashdeep
  hashpump
  hashrat
  hcxtools
  john
  johnny
  jwt-hack
  katana
  kerbrute
  libargon2
  # https://github.com/NixOS/nixpkgs/issues/326909
  # libbde
  libgcrypt
  medusa
  mfoc
  ncrack
  onesixtyone
  pdfcrack
  phrasendrescher
  pixiewps
  psudohash
  python312Packages.myjwt
  # nose-1.3.7 not supported for interpreter python3.12
  python311Packages.patator
  python312Packages.pypykatz
  rarcrack
  reaverwps-t6x
  sha1collisiondetection
  snow
  spiped
  ssdeep
  sslscan
  testssl
  thc-hydra
  truecrack
  veracrypt
  wifite2
  xortool
  ### payloads and wordlists
  payloadsallthethings
  seclists
]
