{ lib }:
let
  inherit (lib) lists;
  inherit (lib.systems) parse;
  inherit (lib.systems.inspect) predicates;
  inherit (lib.attrsets) matchAttrs;

  all = [
    "aarch64-linux"
    "armv5tel-linux" "armv6l-linux" "armv7a-linux" "armv7l-linux"

    "mipsel-linux"

    "i686-cygwin" "i686-freebsd" "i686-linux" "i686-netbsd" "i686-openbsd"

    "x86_64-cygwin" "x86_64-freebsd" "x86_64-linux"
    "x86_64-netbsd" "x86_64-openbsd" "x86_64-solaris"

    "x86_64-darwin" "i686-darwin" "aarch64-darwin" "armv7a-darwin"

    "x86_64-windows" "i686-windows"

    "wasm64-wasi" "wasm32-wasi"

    "x86_64-redox"

    "powerpc64le-linux"

    "riscv32-linux" "riscv64-linux"

    "arm-none" "armv6l-none" "aarch64-none"
    "avr-none"
    "i686-none" "x86_64-none"
    "powerpc-none"
    "msp430-none"
    "riscv64-none" "riscv32-none"
    "vc4-none"

    "js-ghcjs"

    "aarch64-genode" "x86_64-genode"
  ];

  allParsed = map parse.mkSystemFromString all;

  filterDoubles = f: map parse.doubleFromSystem (lists.filter f allParsed);

in {
  inherit all;

  none = [];

  arm     = filterDoubles predicates.isAarch32;
  aarch64 = filterDoubles predicates.isAarch64;
  x86     = filterDoubles predicates.isx86;
  i686    = filterDoubles predicates.isi686;
  x86_64  = filterDoubles predicates.isx86_64;
  mips    = filterDoubles predicates.isMips;
  riscv   = filterDoubles predicates.isRiscV;
  vc4     = filterDoubles predicates.isVc4;
  js      = filterDoubles predicates.isJavaScript;

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
  wasi    = filterDoubles predicates.isWasi;
  redox   = filterDoubles predicates.isRedox;
  windows = filterDoubles predicates.isWindows;
  genode  = filterDoubles predicates.isGenode;

  embedded = filterDoubles predicates.isNone;

  mesaPlatforms = ["i686-linux" "x86_64-linux" "x86_64-darwin" "armv5tel-linux" "armv6l-linux" "armv7l-linux" "armv7a-linux" "aarch64-linux" "powerpc64le-linux"];
}
