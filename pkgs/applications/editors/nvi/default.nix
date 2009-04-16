{ fetchurl, stdenv, ncurses }:

stdenv.mkDerivation rec {
  name = "nvi-1.79";

  src = fetchurl {
    url = ftp://ftp.bostic.com/pub/nvi-1.79.tar.gz;
    sha256 = "0cvf56rbylz7ksny6g2256sjg8yrsxrmbpk82r64rhi53sm8fnvm";
  };

  buildInputs = [ ncurses ];

  patchPhase = ''
    sed -i s/-lcurses/-lncurses/ build/configure
  '';

  configurePhase = ''
    mkdir mybuild
    cd mybuild
    ../build/configure --prefix=$out --disable-curses
  '';

  installPhase = ''
    ensureDir $out/bin $out/share/vi/catalog
    for a in dutch english french german ru_SU.KOI8-R spanish swedish; do
      cp ../catalog/$a $out/share/vi/catalog
    done
    cp nvi $out/bin/nvi
    ln -s $out/bin/nvi $out/bin/vi
    ln -s $out/bin/nvi $out/bin/ex
    ln -s $out/bin/nvi $out/bin/view

    ensureDir $out/share/man/man1
    cp ../docs/USD.doc/vi.man/vi.1 $out/share/man/man1/nvi.1
    ln -s $out/share/man/man1/nvi.1 $out/share/man/man1/vi
    ln -s $out/share/man/man1/nvi.1 $out/share/man/man1/ex
    ln -s $out/share/man/man1/nvi.1 $out/share/man/man1/view
  '';

  meta = {
    homepage = http://www.bostic.com/vi/;
    description = "The Berkeley Vi Editor";
    license = "free";
  };
}
