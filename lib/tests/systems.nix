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
in with lib.systems.doubles; lib.runTests {
  all = assertTrue (mseteq all (linux ++ darwin ++ cygwin ++ freebsd ++ openbsd ++ netbsd ++ illumos));

  arm = assertTrue (mseteq arm [ "armv5tel-linux" "armv6l-linux" "armv7l-linux" ]);
  i686 = assertTrue (mseteq i686 [ "i686-linux" "i686-freebsd" "i686-netbsd" "i686-openbsd" "i686-cygwin" ]);
  mips = assertTrue (mseteq mips [ "mipsel-linux" ]);
  x86_64 = assertTrue (mseteq x86_64 [ "x86_64-linux" "x86_64-darwin" "x86_64-freebsd" "x86_64-openbsd" "x86_64-netbsd" "x86_64-cygwin" "x86_64-solaris" ]);

  cygwin = assertTrue (mseteq cygwin [ "i686-cygwin" "x86_64-cygwin" ]);
  darwin = assertTrue (mseteq darwin [ "x86_64-darwin" ]);
  freebsd = assertTrue (mseteq freebsd [ "i686-freebsd" "x86_64-freebsd" ]);
  gnu = assertTrue (mseteq gnu (linux /* ++ hurd ++ kfreebsd ++ ... */));
  illumos = assertTrue (mseteq illumos [ "x86_64-solaris" ]);
  linux = assertTrue (mseteq linux [ "i686-linux" "x86_64-linux" "armv5tel-linux" "armv6l-linux" "armv7l-linux" "aarch64-linux" "mipsel-linux" ]);
  netbsd = assertTrue (mseteq netbsd [ "i686-netbsd" "x86_64-netbsd" ]);
  openbsd = assertTrue (mseteq openbsd [ "i686-openbsd" "x86_64-openbsd" ]);
  unix = assertTrue (mseteq unix (linux ++ darwin ++ freebsd ++ openbsd ++ netbsd ++ illumos));
}
