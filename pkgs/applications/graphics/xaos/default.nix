{ stdenv, fetchurl, aalib, gsl, libpng, libX11, xproto, libXext
, xextproto, libXt, zlib, gettext, intltool, perl }:

stdenv.mkDerivation rec {
  name = "xaos-${version}";
  version = "3.6";

  src = fetchurl {
    url = "mirror://sourceforge/xaos/${name}.tar.gz";
    sha256 = "15cd1cx1dyygw6g2nhjqq3bsfdj8sj8m4va9n75i0f3ryww3x7wq";
  };

  hardeningDisable = [ "format" ];

  buildInputs = [
    aalib gsl libpng libX11 xproto libXext xextproto
    libXt zlib gettext intltool perl
  ];

  preConfigure = ''
    sed -e s@/usr/@"$out/"@g -i configure $(find . -name 'Makefile*')
    mkdir -p $out/share/locale
  '';

  meta = {
    homepage = http://xaos.sourceforge.net/;
    description = "Fractal viewer";
    license = stdenv.lib.licenses.gpl2Plus;
    platforms = [ "x86_64-linux" ];
  };
}
