let lists = import ../lists.nix; in
let parse = import ./parse.nix; in
let inherit (import ../attrsets.nix) matchAttrs; in

let
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

  arm = filterDoubles (matchAttrs { cpu = { family = "arm"; bits = 32; }; });
  i686 = filterDoubles parse.isi686;
  mips = filterDoubles (matchAttrs { cpu = { family = "mips"; }; });
  x86_64 = filterDoubles parse.isx86_64;

  cygwin = filterDoubles parse.isCygwin;
  darwin = filterDoubles parse.isDarwin;
  freebsd = filterDoubles (matchAttrs { kernel = parse.kernels.freebsd; });
  gnu = filterDoubles (matchAttrs { kernel = parse.kernels.linux; abi = parse.abis.gnu; }); # Should be better
  illumos = filterDoubles (matchAttrs { kernel = parse.kernels.solaris; });
  linux = filterDoubles parse.isLinux;
  netbsd = filterDoubles (matchAttrs { kernel = parse.kernels.netbsd; });
  openbsd = filterDoubles (matchAttrs { kernel = parse.kernels.openbsd; });
  unix = filterDoubles parse.isUnix;

  mesaPlatforms = ["i686-linux" "x86_64-linux" "x86_64-darwin" "armv5tel-linux" "armv6l-linux" "armv7l-linux" "aarch64-linux"];
}
