{ stdenv, fetchurl, pkgconfig, libtool, gtk, libpcap, libglade, libgnome, libgnomeui
, gnomedocutils, scrollkeeper, libxslt }:

stdenv.mkDerivation rec {
  name = "etherape-0.9.13";
  src = fetchurl {
    url = "mirror://sourceforge/etherape/${name}.tar.gz";
    sha256 = "1xq93k1slyak8mgwrw5kymq0xn0kl8chvfcvaablgki4p0l2lg9a";
  };

  configureFlags = [ "--disable-scrollkeeper" ];
  buildInputs = [
    pkgconfig libtool gtk libpcap libglade libgnome libgnomeui gnomedocutils
    scrollkeeper libxslt
  ];

  meta = {
    homepage = http://etherape.sourceforge.net/;
    license = stdenv.lib.licenses.gpl2Plus;
    platforms = with stdenv.lib.platforms; linux;
  };
}
