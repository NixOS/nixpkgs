{ lib, stdenv, fetchurl, autoconf, automake, intltool, libtool, pkg-config, which
, docbook_xml_dtd_45, docbook_xsl, gtkmm2, libgig, libsndfile, libxslt
}:

stdenv.mkDerivation rec {
  pname = "gigedit";
  version = "1.1.1";

  src = fetchurl {
    url = "https://download.linuxsampler.org/packages/${pname}-${version}.tar.bz2";
    sha256 = "08db12crwf0dy1dbyrmivqqpg5zicjikqkmf2kb1ywpq0a9hcxrb";
  };

  preConfigure = "make -f Makefile.svn";

  nativeBuildInputs = [ autoconf automake intltool libtool pkg-config which ];

  buildInputs = [ docbook_xml_dtd_45 docbook_xsl gtkmm2 libgig libsndfile libxslt ];

  enableParallelBuilding = true;

  meta = with lib; {
    homepage = "http://www.linuxsampler.org";
    description = "Gigasampler file access library";
    license = licenses.gpl2;
    maintainers = [ maintainers.goibhniu ];
    platforms = platforms.linux;
  };
}
