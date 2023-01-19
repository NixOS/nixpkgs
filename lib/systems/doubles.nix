{ lib }:
let
  inherit (lib) lists;
  inherit (lib.systems) parse;
  inherit (lib.systems.inspect) predicates;
  inherit (lib.attrsets) matchAttrs;

  all = [
    # Cygwin
    "i686-cygwin" "x86_64-cygwin"

    # Darwin
    "x86_64-darwin" "i686-darwin" "aarch64-darwin" "armv7a-darwin"

    # FreeBSD
    "i686-freebsd13" "x86_64-freebsd13"

    # Genode
    "aarch64-genode" "i686-genode" "x86_64-genode"

    # illumos
    "x86_64-solaris"

    # JS
    "js-ghcjs"

    # Linux
    "aarch64-linux" "armv5tel-linux" "armv6l-linux" "armv7a-linux"
    "armv7l-linux" "i686-linux" "m68k-linux" "microblaze-linux"
    "microblazeel-linux" "mipsel-linux" "mips64el-linux" "powerpc64-linux"
    "powerpc64le-linux" "riscv32-linux" "riscv64-linux" "s390-linux"
    "s390x-linux" "x86_64-linux"

    # MMIXware
    "mmix-mmixware"

    # NetBSD
    "aarch64-netbsd" "armv6l-netbsd" "armv7a-netbsd" "armv7l-netbsd"
    "i686-netbsd" "m68k-netbsd" "mipsel-netbsd" "powerpc-netbsd"
    "riscv32-netbsd" "riscv64-netbsd" "x86_64-netbsd"

    # none
    "aarch64_be-none" "aarch64-none" "arm-none" "armv6l-none" "avr-none" "i686-none"
    "microblaze-none" "microblazeel-none" "msp430-none" "or1k-none" "m68k-none"
    "powerpc-none" "powerpcle-none" "riscv32-none" "riscv64-none" "rx-none"
    "s390-none" "s390x-none" "vc4-none" "x86_64-none"

    # OpenBSD
    "i686-openbsd" "x86_64-openbsd"

    # Redox
    "x86_64-redox"

    # WASI
    "wasm64-wasi" "wasm32-wasi"

    # Windows
    "x86_64-windows" "i686-windows"
  ];

  allParsed = map parse.mkSystemFromString all;

  filterDoubles = f: map parse.doubleFromSystem (lists.filter f allParsed);

in {
  inherit all;

  none = [];

  arm           = filterDoubles predicates.isAarch32;
  armv7         = filterDoubles predicates.isArmv7;
  aarch64       = filterDoubles predicates.isAarch64;
  x86           = filterDoubles predicates.isx86;
  i686          = filterDoubles predicates.isi686;
  x86_64        = filterDoubles predicates.isx86_64;
  microblaze    = filterDoubles predicates.isMicroBlaze;
  mips          = filterDoubles predicates.isMips;
  mmix          = filterDoubles predicates.isMmix;
  riscv         = filterDoubles predicates.isRiscV;
  riscv32       = filterDoubles predicates.isRiscV32;
  riscv64       = filterDoubles predicates.isRiscV64;
  rx            = filterDoubles predicates.isRx;
  vc4           = filterDoubles predicates.isVc4;
  or1k          = filterDoubles predicates.isOr1k;
  m68k          = filterDoubles predicates.isM68k;
  s390          = filterDoubles predicates.isS390;
  js            = filterDoubles predicates.isJavaScript;

  bigEndian     = filterDoubles predicates.isBigEndian;
  littleEndian  = filterDoubles predicates.isLittleEndian;

  cygwin        = filterDoubles predicates.isCygwin;
  darwin        = filterDoubles predicates.isDarwin;
  freebsd       = filterDoubles predicates.isFreeBSD;
  # Should be better, but MinGW is unclear.
  gnu           = filterDoubles (matchAttrs { kernel = parse.kernels.linux; abi = parse.abis.gnu; })
                  ++ filterDoubles (matchAttrs { kernel = parse.kernels.linux; abi = parse.abis.gnueabi; })
                  ++ filterDoubles (matchAttrs { kernel = parse.kernels.linux; abi = parse.abis.gnueabihf; })
                  ++ filterDoubles (matchAttrs { kernel = parse.kernels.linux; abi = parse.abis.gnuabin32; })
                  ++ filterDoubles (matchAttrs { kernel = parse.kernels.linux; abi = parse.abis.gnuabi64; })
                  ++ filterDoubles (matchAttrs { kernel = parse.kernels.linux; abi = parse.abis.gnuabielfv1; })
                  ++ filterDoubles (matchAttrs { kernel = parse.kernels.linux; abi = parse.abis.gnuabielfv2; });
  illumos       = filterDoubles predicates.isSunOS;
  linux         = filterDoubles predicates.isLinux;
  netbsd        = filterDoubles predicates.isNetBSD;
  openbsd       = filterDoubles predicates.isOpenBSD;
  unix          = filterDoubles predicates.isUnix;
  wasi          = filterDoubles predicates.isWasi;
  redox         = filterDoubles predicates.isRedox;
  windows       = filterDoubles predicates.isWindows;
  genode        = filterDoubles predicates.isGenode;

  embedded      = filterDoubles predicates.isNone;

  mesaPlatforms = ["i686-linux" "x86_64-linux" "x86_64-darwin" "armv5tel-linux" "armv6l-linux" "armv7l-linux" "armv7a-linux" "aarch64-linux" "powerpc64-linux" "powerpc64le-linux" "aarch64-darwin" "riscv64-linux"];
}
