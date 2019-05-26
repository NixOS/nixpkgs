{ fetchurl, fetchpatch, stdenv, ncurses }:

stdenv.mkDerivation rec {
  name = "elvis-2.2_0";

  src = fetchurl {
    url = "http://www.the-little-red-haired-girl.org/pub/elvis/elvis-2.2_0.tar.gz";
    sha256 = "182fj9qzyq6cjq1r849gpam6nq9smwv9f9xwaq84961p56r6d14s";
  };

  buildInputs = [ ncurses ];

  patches = [ (fetchpatch {
    url = "https://github.com/mbert/elvis/commit/076cf4ad5cc993be0c6195ec0d5d57e5ad8ac1eb.patch";
    sha256 = "0yzkc1mxjwg09mfmrk20ksa0vfnb2x83ndybwvawq4xjm1qkcahc";
  }) ];

  postPatch = ''
    substituteInPlace configure \
      --replace '-lcurses' '-lncurses'
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

  configureFlags = [ "--ioctl=termios" ];

  meta = {
    homepage = http://elvis.vi-editor.org/;
    description = "A vi clone for Unix and other operating systems";
    license = stdenv.lib.licenses.free;
  };
}
