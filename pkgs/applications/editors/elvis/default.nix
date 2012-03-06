{ fetchurl, stdenv, ncurses }:

stdenv.mkDerivation rec {
  name = "elvis-2.2_0";

  src = fetchurl {
    url = ftp://ftp.cs.pdx.edu/pub/elvis/elvis-2.2_0.tar.gz;
    sha256 = "182fj9qzyq6cjq1r849gpam6nq9smwv9f9xwaq84961p56r6d14s";
  };

  buildInputs = [ ncurses ];

  patchPhase = ''
    sed -i s/-lcurses/-lncurses/ configure
  '';

  preConfigure = ''
    mkdir -p $out/share/man/man1
  '';

  installPhase = ''
    mkdir -p $out/bin $out/share/elvis $out/share/elvis/doc
    cp elvis ref elvtags elvfmt $out/bin
    cp -R data/* $out/share/elvis
    cp doc/* $out/share/elvis/doc

    mkdir -p $out/share/man/man1
    for a in doc/*.man; do
      cp $a $out/share/man/man1/`basename $a .man`.1
    done
  '';

  configureFlags = "--ioctl=termios";

  meta = {
    homepage = http://elvis.vi-editor.org/;
    description = "A vi clone for Unix and other operating systems";
    license = "free";
  };
}
