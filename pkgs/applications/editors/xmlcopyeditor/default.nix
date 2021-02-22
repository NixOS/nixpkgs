{ lib, stdenv, fetchurl, aspell, boost, expat, intltool, libxml2, libxslt, pcre, wxGTK, xercesc }:

stdenv.mkDerivation rec {
  pname = "xmlcopyeditor";
  version = "1.2.1.3";

  src = fetchurl {
    name = "${pname}-${version}.tar.gz";
    url = "mirror://sourceforge/xml-copy-editor/${pname}-${version}.tar.gz";
    sha256 = "0bwxn89600jbrkvlwyawgc0c0qqxpl453mbgcb9qbbxl8984ns4v";
  };

  patches = [ ./xmlcopyeditor.patch ];
  CPLUS_INCLUDE_PATH = "${libxml2.dev}/include/libxml2";

  nativeBuildInputs = [ intltool ];
  buildInputs = [ aspell boost expat libxml2 libxslt pcre wxGTK xercesc ];

  enableParallelBuilding = true;

  meta = with lib; {
    description = "A fast, free, validating XML editor";
    homepage = "http://xml-copy-editor.sourceforge.net/";
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
    maintainers = with maintainers; [ candeira ];
  };
}
