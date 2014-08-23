{ stdenv, fetchsvn, autoconf, automake, docbook_xml_dtd_45
, docbook_xsl, gtkmm, intltool, libgig, libsndfile, libtool, libxslt
, pkgconfig }:

stdenv.mkDerivation rec {
  name = "gigedit-svn-${version}";
  version = "2342";

  src = fetchsvn {
    url = "https://svn.linuxsampler.org/svn/gigedit/trunk";
    rev = "${version}";
    sha256 = "0wi94gymj0ns5ck9lq1d970gb4gnzrq4b57j5j7k3d6185yg2gjs";
  };

  patchPhase = "sed -e 's/which/type -P/g' -i Makefile.cvs";

  preConfigure = "make -f Makefile.cvs";

  buildInputs = [ 
    autoconf automake docbook_xml_dtd_45 docbook_xsl gtkmm intltool
    libgig libsndfile libtool libxslt pkgconfig 
  ];

  meta = with stdenv.lib; {
    homepage = http://www.linuxsampler.org;
    description = "Gigasampler file access library";
    license = licenses.gpl2;
    maintainers = [ maintainers.goibhniu ];
    platforms = platforms.linux;
  };
}
