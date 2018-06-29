{ stdenv, fetchurl, autoconf, automake, intltool, libtool, pkgconfig, which
, docbook_xml_dtd_45, docbook_xsl, gtkmm2, libgig, libsndfile, libxslt
}:

stdenv.mkDerivation rec {
  name = "gigedit-${version}";
  version = "1.1.0";

  src = fetchurl {
    url = "https://download.linuxsampler.org/packages/${name}.tar.bz2";
    sha256 = "087pc919q28r1vw31c7w4m14bqnp4md1i2wbmk8w0vmwv2cbx2ni";
  };

  patches = [ ./gigedit-1.1.0-pangomm-2.40.1.patch ];

  preConfigure = "make -f Makefile.svn";

  nativeBuildInputs = [ autoconf automake intltool libtool pkgconfig which ];

  buildInputs = [ docbook_xml_dtd_45 docbook_xsl gtkmm2 libgig libsndfile libxslt ];

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    homepage = http://www.linuxsampler.org;
    description = "Gigasampler file access library";
    license = licenses.gpl2;
    maintainers = [ maintainers.goibhniu ];
    platforms = platforms.linux;
  };
}
