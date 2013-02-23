{ stdenv, fetchurl, pkgconfig, libtool, gtk, libpcap, libglade, libgnome, libgnomeui
, gnomedocutils, scrollkeeper, libxslt }:

stdenv.mkDerivation rec {
  name = "etherape-0.9.12";
  src = fetchurl {
    url = "mirror://sourceforge/etherape/${name}.tar.gz";
    sha256 = "0ici0aqw2r221lc3rhrdcnvavbhcj0ybwawgrhh399i74w7wf14k";
  };

  configureFlags = [ "--disable-scrollkeeper" ];
  buildInputs = [
    pkgconfig libtool gtk libpcap libglade libgnome libgnomeui gnomedocutils
    scrollkeeper libxslt
  ];

  meta = {
    homepage = http://etherape.sourceforge.net/;
    license = "GPLv2+";
    platforms = with stdenv.lib.platforms; linux;
  };
}
