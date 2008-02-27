args: with args;
stdenv.mkDerivation {
  name = "freemind-0.9.0_Beta_13";

  src = fetchurl {
    url = http://downloads.sourceforge.net/freemind/freemind-src-0.9.0_Beta_13_icon_butterfly.tar.gz;
    sha256 = "00389bhg73qknydrq0f3bskb5lyrdg2p58mnnp19wdvzzmfbic4w";
  };

  buildInputs = [jdk ant];

  inherit jre;

  phases="unpackPhase buildPhase installPhase";

  buildPhase="ant dist";
# LIBXCB_ALLOW_SLOPPY_LOCK=true :
# don't know yet what this option really means but I'm no longer getting
#   Checking Java Version...
#   Locking assertion failure.  Backtrace:
#   java: xcb_xlib.c:82: xcb_xlib_unlock: Assertion `c->xlib.lock' failed
# this way
# reference and more info https://bugs.launchpad.net/ubuntu/+source/sun-java5/+bug/86103
# JDK 7 beta seems to have fixed this (bug ?)

  installPhase="
    ensureDir \$out/{bin,nix-support}
    cp -r ../bin/dist \$out/nix-support
    sed -i 's/which/type -p/' \$out/nix-support/dist/freemind.sh
    cat > \$out/bin/freemind << EOF
#!/bin/sh
export LIBXCB_ALLOW_SLOPPY_LOCK=true
export JAVA_HOME=\$jre
\$out/nix-support/dist/freemind.sh
EOF

    chmod +x \$out/{bin/freemind,nix-support/dist/freemind.sh}
    ";

  meta = {
      description = "mind mapping software";
      homepage = http://freemind.sourceforge.net/wiki/index.php/Main_Page;
      license = "GPL";
  }; 
}
