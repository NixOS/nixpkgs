# We assert that the new algorithmic way of generating these lists matches the
# way they were hard-coded before.
#
# One might think "if we exhaustively test, what's the point of procedurally
# calculating the lists anyway?". The answer is one can mindlessly update these
# tests as new platforms become supported, and then just give the diff a quick
# sanity check before committing :).
let
  lib = import ../default.nix;
  mseteq = x: y: {
    expr     = lib.sort lib.lessThan x;
    expected = lib.sort lib.lessThan y;
  };
in
with lib.systems.doubles; lib.runTests {
  testall = mseteq all (linux ++ darwin ++ freebsd ++ openbsd ++ netbsd ++ illumos ++ wasi ++ windows ++ embedded ++ mmix ++ js ++ genode ++ redox);

  testarm = mseteq arm [ "armv7a-darwin" "armv5tel-freebsd" "armv6l-freebsd" "armv7l-freebsd" "armv5tel-linux" "armv6l-linux" "armv7a-linux" "armv7l-linux" "armv6l-netbsd" "armv7a-netbsd" "armv7l-netbsd" "arm-none" "armv6l-none" "armv7l-openbsd" ];
  testi686 = mseteq i686 [ "i686-cygwin" "i686-darwin" "i686-freebsd" "i686-genode" "i686-linux" "i686-netbsd" "i686-none" "i686-openbsd" "i686-windows" ];
  testmips = mseteq mips [ "mipsel-freebsd" "mipsel-linux" "mipsel-netbsd" ];
  testmmix = mseteq mmix [ "mmix-mmixware" ];
  testx86_64 = mseteq x86_64 [ "x86_64-cygwin" "x86_64-darwin" "x86_64-freebsd" "x86_64-genode" "x86_64-solaris" "x86_64-linux" "x86_64-netbsd" "x86_64-none" "x86_64-openbsd" "x86_64-redox" "x86_64-windows" ];

  testcygwin = mseteq cygwin [ "i686-cygwin" "x86_64-cygwin" ];
  testdarwin = mseteq darwin [ "x86_64-darwin" "i686-darwin" "aarch64-darwin" "armv7a-darwin" ];
  testfreebsd = mseteq freebsd [ "aarch64-freebsd" "armv5tel-freebsd" "armv6l-freebsd" "armv7l-freebsd" "i686-freebsd" "mipsel-freebsd" "powerpc64-freebsd" "riscv64-freebsd" "sparc64-freebsd" "x86_64-freebsd" ];
  testgenode = mseteq genode [ "aarch64-genode" "i686-genode" "x86_64-genode" ];
  testredox = mseteq redox [ "x86_64-redox" ];
  testgnu = mseteq gnu (linux /* ++ kfreebsd ++ ... */);
  testillumos = mseteq illumos [ "x86_64-solaris" ];
  testlinux = mseteq linux [ "aarch64-linux" "armv5tel-linux" "armv6l-linux" "armv7a-linux" "armv7l-linux" "i686-linux" "m68k-linux" "mipsel-linux" "powerpc64-linux" "powerpc64le-linux" "riscv32-linux" "riscv64-linux" "s390-linux" "s390x-linux" "sparc64-linux" "x86_64-linux" ];
  testnetbsd = mseteq netbsd [ "aarch64-netbsd" "armv6l-netbsd" "armv7a-netbsd" "armv7l-netbsd" "i686-netbsd" "m68k-netbsd" "mipsel-netbsd" "powerpc-netbsd" "riscv32-netbsd" "riscv64-netbsd" "sparc64-netbsd" "x86_64-netbsd" ];
  testopenbsd = mseteq openbsd [ "aarch64-openbsd" "armv7l-openbsd" "i686-openbsd" "powerpc64-openbsd" "riscv64-openbsd" "sparc64-openbsd" "x86_64-openbsd" ];
  testwindows = mseteq windows [ "i686-cygwin" "x86_64-cygwin" "x86_64-windows" "i686-windows" "aarch64-windows" ];
  testunix = mseteq unix (linux ++ darwin ++ freebsd ++ openbsd ++ netbsd ++ illumos ++ cygwin ++ redox);
}
