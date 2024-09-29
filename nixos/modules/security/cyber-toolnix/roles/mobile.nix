{ pkgs, ... }:

with pkgs;

[
  amoco
  android-udev-rules
  apkid
  apkleaks
  apktool
  binwalk
  bsdiff
  capstone
  cargo-ndk
  ctypes_sh
  # https://github.com/NixOS/nixpkgs/issues/308262
  # cutter
  # cutterPlugins.rz-ghidra
  dex2jar
  edb
  eresi
  flasm
  frida-tools
  ghidra
  ghost
  hopper
  iaito
  jadx
  # https://github.com/NixOS/nixpkgs/issues/308260
  # jd-cli
  jd-gui
  jsbeautifier
  kalibrate-rtl
  # https://github.com/NixOS/nixpkgs/issues/326927
  # klee
  lief
  pe-bear
  pev
  pwntools
  # capstone-5.0.1 not supported for interpreter python3.12
  python311Packages.angr
  # distorm3-3.5.2 not supported for interpreter python3.12
  # https://github.com/NixOS/nixpkgs/issues/326920
  # python311Packages.distorm3
  python312Packages.frida-python
  # capstone-5.0.1 not supported for interpreter python3.12
  python311Packages.pwntools
  python312Packages.pyaxmlparser
  python312Packages.pyjsparser
  quark-engine
  radare2
  retdec
  rizin
  rizinPlugins.rz-ghidra
  scanmem
  # swftools
  udis86
  vivisect
]
