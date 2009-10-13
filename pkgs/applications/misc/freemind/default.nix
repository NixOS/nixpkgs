args: with args;
stdenv.mkDerivation {
  name = "freemind-0.9.0_Beta_20";

  src = fetchurl {
    url = mirror://sourceforge/freemind/freemind-src-0.9.0_Beta_20.tar.gz;
    sha256 = "1ja573n0g9zpdrljabgps20njg1p76hvsv8xjb56cii2dr77yspv";
  };

  buildInputs = [jdk ant];

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

  installPhase=''
    ensureDir $out/{bin,nix-support}
    cp -r ../bin/dist $out/nix-support
    sed -i 's/which/type -p/' $out/nix-support/dist/freemind.sh
    cat > $out/bin/freemind << EOF
    #!/bin/sh
    export PATH=${args.coreutils}/bin:${args.gnugrep}/bin:"$PATH"
    export JAVA_HOME="${jre}"
    export LIBXCB_ALLOW_SLOPPY_LOCK=true
    $out/nix-support/dist/freemind.sh
    EOF

    chmod +x $out/{bin/freemind,nix-support/dist/freemind.sh}
    '';

  meta = {
      description = "mind mapping software";
      homepage = http://freemind.sourceforge.net/wiki/index.php/Main_Page;
      license = "GPL";
  }; 
}
