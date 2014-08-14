let lists = import ./lists.nix; in

rec {
  gnu = linux; /* ++ hurd ++ kfreebsd ++ ... */
  linux = ["i686-linux" "x86_64-linux" "armv5tel-linux" "armv7l-linux" "mips64el-linux"];
  darwin = ["x86_64-darwin"];
  freebsd = ["i686-freebsd" "x86_64-freebsd"];
  openbsd = ["i686-openbsd" "x86_64-openbsd"];
  netbsd = ["i686-netbsd" "x86_64-netbsd"];
  cygwin = ["i686-cygwin"];
  unix = linux ++ darwin ++ freebsd ++ openbsd;
  all = linux ++ darwin ++ cygwin ++ freebsd ++ openbsd;
  none = [];
  allBut = platforms: lists.filter (x: !(builtins.elem x platforms)) all;
  mesaPlatforms = ["i686-linux" "x86_64-linux" "x86_64-darwin" "armv5tel-linux" "armv6l-linux"];
}
