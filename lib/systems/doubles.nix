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
    "i586-cygwin" "i586-freebsd" "i586-linux" "i586-netbsd" "i586-openbsd"
    "i486-cygwin" "i486-freebsd" "i486-linux" "i486-netbsd" "i486-openbsd"
    "i386-cygwin" "i386-freebsd" "i386-linux" "i386-netbsd" "i386-openbsd"

    "x86_64-cygwin" "x86_64-darwin" "x86_64-freebsd" "x86_64-linux"
    "x86_64-netbsd" "x86_64-openbsd" "x86_64-solaris"

    "x86_64-windows" "i686-windows" "i586-windows"
  ];

  allParsed = map parse.mkSystemFromString all;

  filterDoubles = f: map parse.doubleFromSystem (lists.filter f allParsed);

in rec {
  inherit all;

  none = [];

  arm     = filterDoubles predicates.isAarch32;
  aarch64 = filterDoubles predicates.isAarch64;
  x86     = filterDoubles predicates.isx86;
  i386    = filterDoubles predicates.isi386;
  i486    = filterDoubles predicates.isi486;
  i586    = filterDoubles predicates.isi586;
  i686    = filterDoubles predicates.isi686;
  x86_32  = filterDoubles predicates.isx86_32;
  x86_64  = filterDoubles predicates.isx86_64;
  mips    = filterDoubles predicates.isMips;

  cygwin  = filterDoubles predicates.isCygwin;
  darwin  = filterDoubles predicates.isDarwin;
  freebsd = filterDoubles predicates.isFreeBSD;
  # Should be better, but MinGW is unclear.
  gnu     = filterDoubles (matchAttrs { kernel = parse.kernels.linux; abi = parse.abis.gnu; }) ++ filterDoubles (matchAttrs { kernel = parse.kernels.linux; abi = parse.abis.gnueabi; }) ++ filterDoubles (matchAttrs { kernel = parse.kernels.linux; abi = parse.abis.gnueabihf; });
  illumos = filterDoubles predicates.isSunOS;
  linux   = filterDoubles predicates.isLinux;
  netbsd  = filterDoubles predicates.isNetBSD;
  openbsd = filterDoubles predicates.isOpenBSD;
  unix    = filterDoubles predicates.isUnix;
  windows = filterDoubles predicates.isWindows;

  mesaPlatforms = ["i686-linux" "x86_64-linux" "x86_64-darwin" "armv5tel-linux" "armv6l-linux" "armv7l-linux" "aarch64-linux" "powerpc64le-linux"];
}
