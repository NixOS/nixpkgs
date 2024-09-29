{ pkgs, ... }:

with pkgs;

[
  amass
  # https://github.com/NixOS/nixpkgs/pull/326533
  # clamav
  cryptsetup
  ddrescue
  exploitdb
  ext4magic
  extundelete
  foremost
  fwbuilder
  ghidra
  netsniff-ng
  python312Packages.impacket
  recoverjpeg
  sleuthkit
  wapiti
  wireshark
  zap
]
