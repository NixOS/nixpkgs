{ stdenv, fetchurl, jdk, jre, ant, coreutils, gnugrep }:

stdenv.mkDerivation {
  name = "freemind-0.9.0";

  src = fetchurl {
    url = mirror://sourceforge/freemind/freemind-src-0.9.0.tar.gz;
    sha256 = "1qd535gwx00d8z56mplxli5529yds2gsmbgla5b0bhhmsdwmrxmf";
  };

  buildInputs = [ jdk ant ];

  phases = "unpackPhase patchPhase buildPhase installPhase";

  patchPhase = ''
    # There is a complain about this. I don't understand it.
    mkdir plugins/plugins
  '';

  buildPhase="ant dist";
  
  # LIBXCB_ALLOW_SLOPPY_LOCK=true :
  # don't know yet what this option really means but I'm no longer getting
  #   Checking Java Version...
  #   Locking assertion failure.  Backtrace:
  #   java: xcb_xlib.c:82: xcb_xlib_unlock: Assertion `c->xlib.lock' failed
  # this way
  # reference and more info https://bugs.launchpad.net/ubuntu/+source/sun-java5/+bug/86103
  # JDK 7 beta seems to have fixed this (bug ?)

  installPhase = ''
    ensureDir $out/{bin,nix-support}
    cp -r ../bin/dist $out/nix-support
    sed -i 's/which/type -p/' $out/nix-support/dist/freemind.sh
    cat > $out/bin/freemind << EOF
    #!/bin/sh
    export PATH=${coreutils}/bin:${gnugrep}/bin:"$PATH"
    export JAVA_HOME="${jre}"
    export LIBXCB_ALLOW_SLOPPY_LOCK=true
    $out/nix-support/dist/freemind.sh
    EOF

    chmod +x $out/{bin/freemind,nix-support/dist/freemind.sh}
  '';

  meta = {
    description = "Mind-mapping software";
    homepage = http://freemind.sourceforge.net/wiki/index.php/Main_Page;
    license = "GPL";
  }; 
}
