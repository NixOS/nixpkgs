{ lib }:
let
  inherit (lib) lists;
  inherit (lib.systems) parse;
  inherit (lib.systems.inspect) predicates;
  inherit (lib.attrsets) matchAttrs;

  all = [
    "aarch64-linux"
    "armv5tel-linux" "armv6l-linux" "armv7l-linux"

    "mipsel-linux"

    "i686-cygwin" "i686-freebsd" "i686-linux" "i686-netbsd" "i686-openbsd"

    "x86_64-cygwin" "x86_64-darwin" "x86_64-freebsd" "x86_64-linux"
    "x86_64-netbsd" "x86_64-openbsd" "x86_64-solaris"
  ];

  allParsed = map parse.mkSystemFromString all;

  filterDoubles = f: map parse.doubleFromSystem (lists.filter f allParsed);

in rec {
  inherit all;

  none = [];

  arm     = filterDoubles predicates.isAarch32;
  aarch64 = filterDoubles predicates.isAarch64;
  x86     = filterDoubles predicates.isx86;
  i686    = filterDoubles predicates.isi686;
  x86_64  = filterDoubles predicates.isx86_64;
  mips    = filterDoubles predicates.isMips;

  cygwin  = filterDoubles predicates.isCygwin;
  darwin  = filterDoubles predicates.isDarwin;
  freebsd = filterDoubles predicates.isFreeBSD;
  # Should be better, but MinGW is unclear, and HURD is bit-rotted.
  gnu     = filterDoubles (matchAttrs { kernel = parse.kernels.linux; abi = parse.abis.gnu; });
  illumos = filterDoubles predicates.isSunOS;
  linux   = filterDoubles predicates.isLinux;
  netbsd  = filterDoubles predicates.isNetBSD;
  openbsd = filterDoubles predicates.isOpenBSD;
  unix    = filterDoubles predicates.isUnix;

  mesaPlatforms = ["i686-linux" "x86_64-linux" "x86_64-darwin" "armv5tel-linux" "armv6l-linux" "armv7l-linux" "aarch64-linux" "powerpc64le-linux"];
}
