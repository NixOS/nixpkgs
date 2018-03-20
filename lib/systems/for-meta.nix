{ lib }:
let
  inherit (lib.systems) parse;
  inherit (lib.systems.inspect) patterns;

in rec {
  inherit (lib.systems.doubles) all mesaPlatforms;
  none = [];

  arm     = [ patterns.isArm ];
  aarch64 = [ patterns.isAarch64 ];
  x86     = [ patterns.isx86 ];
  i686    = [ patterns.isi686 ];
  x86_64  = [ patterns.isx86_64 ];
  mips    = [ patterns.isMips ];

  cygwin  = [ patterns.isCygwin ];
  darwin  = [ patterns.isDarwin ];
  freebsd = [ patterns.isFreeBSD ];
  # Should be better, but MinGW is unclear, and HURD is bit-rotted.
  gnu     = [ { kernel = parse.kernels.linux; abi = parse.abis.gnu; } ];
  illumos = [ patterns.isSunOS ];
  linux   = [ patterns.isLinux ];
  netbsd  = [ patterns.isNetBSD ];
  openbsd = [ patterns.isOpenBSD ];
  unix    = patterns.isUnix; # Actually a list
}
