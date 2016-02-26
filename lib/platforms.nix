let lists = import ./lists.nix; in

rec {
  all = linux ++ darwin ++ cygwin ++ freebsd ++ openbsd ++ netbsd ++ illumos;
  allBut = platforms: lists.filter (x: !(builtins.elem x platforms)) all;
  none = [];

  arm = ["armv5tel-linux" "armv6l-linux" "armv7l-linux" ];
  i686 = ["i686-linux" "i686-freebsd" "i686-netbsd" "i686-cygwin"];
  mips = [ "mips64el-linux" ];
  x86_64 = ["x86_64-linux" "x86_64-darwin" "x86_64-freebsd" "x86_64-openbsd" "x86_64-netbsd" "x86_64-cygwin"];

  cygwin = ["i686-cygwin" "x86_64-cygwin"];
  darwin = ["x86_64-darwin"];
  freebsd = ["i686-freebsd" "x86_64-freebsd"];
  gnu = linux; /* ++ hurd ++ kfreebsd ++ ... */
  illumos = ["x86_64-solaris"];
  linux = ["i686-linux" "x86_64-linux" "armv5tel-linux" "armv6l-linux" "armv7l-linux" "mips64el-linux"];
  netbsd = ["i686-netbsd" "x86_64-netbsd"];
  openbsd = ["i686-openbsd" "x86_64-openbsd"];
  unix = linux ++ darwin ++ freebsd ++ openbsd ++ netbsd ++ illumos;

  mesaPlatforms = ["i686-linux" "x86_64-linux" "x86_64-darwin" "armv5tel-linux" "armv6l-linux" "armv7l-linux"];
}
