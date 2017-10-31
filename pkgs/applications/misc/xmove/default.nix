{stdenv, fetchurl, libX11, libXi, imake, xauth, libXau}:
stdenv.mkDerivation {
  name = "xmove-2.0b2";

  src = fetchurl {
    url = mirror://debian/pool/main/x/xmove/xmove_2.0beta2.orig.tar.gz;
    sha256 = "0q310k3bi39vdk0kqqvsahnb1k6lx9hlx80iyxnkq59l6jxnhyhf";
  };

  buildPhase = "cd xmove; sed -e 's/.*No address for our host.*/{hp = gethostbyname(\"localhost\");};/' -i main.c; cp ../man/man1/xmove.1 xmove.man ; xmkmf; make; cd .. ; cd xmovectrl ; cp ../man/man1/xmovectrl.1 xmovectrl.man; xmkmf; make ; cd ..";
  installPhase = "cd xmove; make install install.man MANDIR=\${out}/man/man1 BINDIR=\${out}/bin; cd .. ; cd xmovectrl ; make install install.man MANDIR=\${out}/man/man1 BINDIR=\${out}/bin; cd ..";

  buildInputs = [libX11 libXi imake xauth libXau];

  meta = {
    platforms = stdenv.lib.platforms.linux;
  };
}
