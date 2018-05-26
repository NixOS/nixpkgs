{ lib }:
let
  inherit (lib.systems) parse;
  inherit (lib.systems.inspect) patterns;

  abis = lib.mapAttrs (_: abi: builtins.removeAttrs abi [ "assertions" ]) parse.abis;

in rec {
  all     = [ {} ]; # `{}` matches anything
  none    = [];

  arm     = [ patterns.isAarch32 ];
  aarch64 = [ patterns.isAarch64 ];
  x86     = [ patterns.isx86 ];
  i686    = [ patterns.isi686 ];
  x86_64  = [ patterns.isx86_64 ];
  mips    = [ patterns.isMips ];
  riscv   = [ patterns.isRiscV ];

  cygwin  = [ patterns.isCygwin ];
  darwin  = [ patterns.isDarwin ];
  freebsd = [ patterns.isFreeBSD ];
  # Should be better, but MinGW is unclear, and HURD is bit-rotted.
  gnu     = [
    { kernel = parse.kernels.linux; abi = parse.abis.gnu; }
    { kernel = parse.kernels.linux; abi = parse.abis.gnueabi; }
    { kernel = parse.kernels.linux; abi = parse.abis.gnueabihf; }
  ];
  illumos = [ patterns.isSunOS ];
  linux   = [ patterns.isLinux ];
  netbsd  = [ patterns.isNetBSD ];
  openbsd = [ patterns.isOpenBSD ];
  unix    = patterns.isUnix; # Actually a list
  windows = [ patterns.isWindows ];

  inherit (lib.systems.doubles) mesaPlatforms;
}
