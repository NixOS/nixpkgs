{ stdenv, fetchurl, perl, perlXMLParser, pkgconfig, gtk
, scrollkeeper, libglade, libXmu, libXext}:

stdenv.mkDerivation {
  name = "xvidcap-1.1.4p1";
  
  src = fetchurl {
    url = mirror://sourceforge/xvidcap/xvidcap-1.1.4p1.tar.gz;
    md5 = "35a038dba807f6e09f1d9dd2bc0c5719";
  };
  
  buildInputs = [perl perlXMLParser pkgconfig gtk scrollkeeper libglade libXmu];

  # !!! don't know why this is necessary
  NIX_LDFLAGS = "-rpath ${libXext}/lib";

  meta = { 
    description = "screencast video catpuring tool";
    homepage = http://xvidcap.sourceforge.net/;
    license = "GPLv2";
  };
}
