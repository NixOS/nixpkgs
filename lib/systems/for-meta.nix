{ lib }:
let
  inherit (lib.systems) parse;
  inherit (lib.systems.inspect) patterns;

in rec {
  inherit (lib.systems.doubles) all mesaPlatforms;
  none = [];

  arm     = [ patterns.Arm ];
  aarch64 = [ patterns.Aarch64 ];
  x86     = [ patterns.x86 ];
  i686    = [ patterns.i686 ];
  x86_64  = [ patterns.x86_64 ];
  mips    = [ patterns.Mips ];

  cygwin  = [ patterns.Cygwin ];
  darwin  = [ patterns.Darwin ];
  freebsd = [ patterns.FreeBSD ];
  # Should be better, but MinGW is unclear, and HURD is bit-rotted.
  gnu     = [ { kernel = parse.kernels.linux; abi = parse.abis.gnu; } ];
  illumos = [ patterns.SunOS ];
  linux   = [ patterns.Linux ];
  netbsd  = [ patterns.NetBSD ];
  openbsd = [ patterns.OpenBSD ];
  unix    = patterns.Unix; # Actually a list
}
