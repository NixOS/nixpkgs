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

  testarm = mseteq arm [ "armv5tel-linux" "armv6l-linux" "armv6l-netbsd" "armv6l-none" "armv7a-linux" "armv7a-netbsd" "armv7l-linux" "armv7l-netbsd" "arm-none" "armv7a-darwin" ];
  testarmv7 = mseteq armv7 [ "armv7a-darwin" "armv7a-linux" "armv7l-linux" "armv7a-netbsd" "armv7l-netbsd" ];
  testi686 = mseteq i686 [ "i686-linux" "i686-freebsd13" "i686-genode" "i686-netbsd" "i686-openbsd" "i686-cygwin" "i686-windows" "i686-none" "i686-darwin" ];
  testmips = mseteq mips [ "mips64el-linux" "mipsel-linux" "mipsel-netbsd" ];
  testmmix = mseteq mmix [ "mmix-mmixware" ];
  testpower = mseteq power [ "powerpc-netbsd" "powerpc-none" "powerpc64-linux" "powerpc64le-linux" "powerpcle-none" ];
  testriscv = mseteq riscv [ "riscv32-linux" "riscv64-linux" "riscv32-netbsd" "riscv64-netbsd" "riscv32-none" "riscv64-none" ];
  testriscv32 = mseteq riscv32 [ "riscv32-linux" "riscv32-netbsd" "riscv32-none" ];
  testriscv64 = mseteq riscv64 [ "riscv64-linux" "riscv64-netbsd" "riscv64-none" ];
  testx86_64 = mseteq x86_64 [ "x86_64-linux" "x86_64-darwin" "x86_64-freebsd13" "x86_64-genode" "x86_64-redox" "x86_64-openbsd" "x86_64-netbsd" "x86_64-cygwin" "x86_64-solaris" "x86_64-windows" "x86_64-none" ];

  testcygwin = mseteq cygwin [ "i686-cygwin" "x86_64-cygwin" ];
  testdarwin = mseteq darwin [ "x86_64-darwin" "i686-darwin" "aarch64-darwin" "armv7a-darwin" ];
  testfreebsd = mseteq freebsd [ "i686-freebsd13" "x86_64-freebsd13" ];
  testgenode = mseteq genode [ "aarch64-genode" "i686-genode" "x86_64-genode" ];
  testredox = mseteq redox [ "x86_64-redox" ];
  testgnu = mseteq gnu (linux /* ++ kfreebsd ++ ... */);
  testillumos = mseteq illumos [ "x86_64-solaris" ];
  testlinux = mseteq linux [ "aarch64-linux" "armv5tel-linux" "armv6l-linux" "armv7a-linux" "armv7l-linux" "i686-linux" "mips64el-linux" "mipsel-linux" "riscv32-linux" "riscv64-linux" "x86_64-linux" "powerpc64-linux" "powerpc64le-linux" "m68k-linux" "s390-linux" "s390x-linux" "microblaze-linux" "microblazeel-linux" ];
  testnetbsd = mseteq netbsd [ "aarch64-netbsd" "armv6l-netbsd" "armv7a-netbsd" "armv7l-netbsd" "i686-netbsd" "m68k-netbsd" "mipsel-netbsd" "powerpc-netbsd" "riscv32-netbsd" "riscv64-netbsd" "x86_64-netbsd" ];
  testopenbsd = mseteq openbsd [ "i686-openbsd" "x86_64-openbsd" ];
  testwindows = mseteq windows [ "i686-cygwin" "x86_64-cygwin" "i686-windows" "x86_64-windows" ];
  testunix = mseteq unix (linux ++ darwin ++ freebsd ++ openbsd ++ netbsd ++ illumos ++ cygwin ++ redox);
}
