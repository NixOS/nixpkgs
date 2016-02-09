let lists = import ./lists.nix; in

rec {
  gnu = linux; /* ++ hurd ++ kfreebsd ++ ... */
  linux = ["i686-linux" "x86_64-linux" "armv5tel-linux" "armv6l-linux" "armv7l-linux" "mips64el-linux"];
  darwin = ["x86_64-darwin"];
  freebsd = ["i686-freebsd" "x86_64-freebsd"];
  openbsd = ["i686-openbsd" "x86_64-openbsd"];
  netbsd = ["i686-netbsd" "x86_64-netbsd"];
  cygwin = ["i686-cygwin" "x86_64-cygwin"];
  illumos = ["x86_64-solaris"];
  unix = linux ++ darwin ++ freebsd ++ openbsd ++ netbsd ++ illumos;
  all = linux ++ darwin ++ cygwin ++ freebsd ++ openbsd ++ netbsd ++ illumos;
  none = [];
  allBut = platforms: lists.filter (x: !(builtins.elem x platforms)) all;
  mesaPlatforms = ["i686-linux" "x86_64-linux" "x86_64-darwin" "armv5tel-linux" "armv6l-linux" "armv7l-linux"];
  x86_64 = ["x86_64-linux" "x86_64-darwin" "x86_64-freebsd" "x86_64-openbsd" "x86_64-netbsd" "x86_64-cygwin"];
  i686 = ["i686-linux" "i686-freebsd" "i686-netbsd" "i686-cygwin"];
  arm = ["armv5tel-linux" "armv6l-linux" "armv7l-linux" ];
  mips = [ "mips64el-linux" ];
}
