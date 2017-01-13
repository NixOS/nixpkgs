{ fetchurl, stdenv, ncurses }:

stdenv.mkDerivation rec {
  name = "nvi-1.79";

  src = fetchurl {
    urls =
      [ "ftp://ftp.eenet.ee/pub/cpan/src/misc/nvi-1.79.tar.gz"
        "ftp://ftp.saintjoe.edu/pub/CPAN/src/misc/nvi-1.79.tar.gz"
        "ftp://ftp.free.fr/.mirrors1/ftp.netbsd.org/packages/distfiles/nvi-1.79.tar.gz"
      ];
    sha256 = "0cvf56rbylz7ksny6g2256sjg8yrsxrmbpk82r64rhi53sm8fnvm";
  };

  buildInputs = [ ncurses ];

  # nvi tries to write to a usual tmp directory (/var/tmp),
  # so we will force it to use /tmp.
  patchPhase = ''
    sed -i build/configure \
      -e s@vi_cv_path_preserve=no@vi_cv_path_preserve=/tmp/vi.recover@ \
      -e s@/var/tmp@@ \
      -e s@-lcurses@-lncurses@
  '';

  configurePhase = ''
    mkdir mybuild
    cd mybuild
    ../build/configure --prefix=$out --disable-curses
  '';

  installPhase = ''
    mkdir -p $out/bin $out/share/vi/catalog
    for a in dutch english french german ru_SU.KOI8-R spanish swedish; do
      cp ../catalog/$a $out/share/vi/catalog
    done
    cp nvi $out/bin/nvi
    ln -s $out/bin/nvi $out/bin/vi
    ln -s $out/bin/nvi $out/bin/ex
    ln -s $out/bin/nvi $out/bin/view

    mkdir -p $out/share/man/man1
    cp ../docs/USD.doc/vi.man/vi.1 $out/share/man/man1/nvi.1
    ln -s $out/share/man/man1/nvi.1 $out/share/man/man1/vi
    ln -s $out/share/man/man1/nvi.1 $out/share/man/man1/ex
    ln -s $out/share/man/man1/nvi.1 $out/share/man/man1/view
    ln -s $out/bin/{,vi-}nvi # create a symlink so that all vi(m) users will find it
  '';

  meta = {
    homepage = http://www.bostic.com/vi/;
    description = "The Berkeley Vi Editor";
    license = stdenv.lib.licenses.free;
  };
}
