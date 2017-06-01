let
  lists = import ../lists.nix;
  parse = import ./parse.nix;
  inherit (import ./inspect.nix) predicates;
  inherit (import ../attrsets.nix) matchAttrs;

  all = [
    "aarch64-linux"
    "armv5tel-linux" "armv6l-linux" "armv7l-linux"

    "mips64el-linux"

    "i686-cygwin" "i686-freebsd" "i686-linux" "i686-netbsd" "i686-openbsd"

    "x86_64-cygwin" "x86_64-darwin" "x86_64-freebsd" "x86_64-linux"
    "x86_64-netbsd" "x86_64-openbsd" "x86_64-solaris"
  ];

  allParsed = map parse.mkSystemFromString all;

  filterDoubles = f: map parse.doubleFromSystem (lists.filter f allParsed);

in rec {
  inherit all;

  allBut = platforms: lists.filter (x: !(builtins.elem x platforms)) all;
  none = [];

  arm     = filterDoubles predicates.isArm32;
  i686    = filterDoubles predicates.isi686;
  mips    = filterDoubles predicates.isMips;
  x86_64  = filterDoubles predicates.isx86_64;

  cygwin  = filterDoubles predicates.isCygwin;
  darwin  = filterDoubles predicates.isDarwin;
  freebsd = filterDoubles predicates.isFreeBSD;
  # Should be better, but MinGW is unclear, and HURD is bit-rotted.
  gnu     = filterDoubles (matchAttrs { kernel = parse.kernels.linux;  abi = parse.abis.gnu; });
  illumos = filterDoubles predicates.isSunOS;
  linux   = filterDoubles predicates.isLinux;
  netbsd  = filterDoubles predicates.isNetBSD;
  openbsd = filterDoubles predicates.isOpenBSD;
  unix    = filterDoubles predicates.isUnix;

  mesaPlatforms = ["i686-linux" "x86_64-linux" "x86_64-darwin" "armv5tel-linux" "armv6l-linux" "armv7l-linux" "aarch64-linux"];
}
