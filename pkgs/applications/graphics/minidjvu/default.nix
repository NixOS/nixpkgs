{stdenv, fetchurl, libtiff, gettext }:

stdenv.mkDerivation {
  name = "minidjvu-0.8";
  src = fetchurl {
    url = mirror://sourceforge/minidjvu/minidjvu-0.8.tar.gz;
    sha256 = "0jmpvy4g68k6xgplj9zsl6brg6vi81mx3nx2x9hfbr1f4zh95j79";
  };

  patchPhase = ''
    sed -i s,/usr/bin/gzip,gzip, Makefile.in
  '';

  buildInputs = [ libtiff gettext];

  preInstall = ''
    mkdir -p $out/lib
  '';

  meta = {
    homepage = http://djvu.sourceforge.net/djview4.html;
    description = "Black-and-white djvu page encoder and decoder that use interpage information";
    license = stdenv.lib.licenses.gpl2Plus;
    maintainers = [ stdenv.lib.maintainers.viric ];
  };
}
