{ stdenv, fetchurl, aspell, boost, expat, expect, intltool, libxml2, libxslt, pcre, wxGTK, xercesc }:

stdenv.mkDerivation rec {
  name = "xmlcopyeditor-${version}";
  version = "1.2.1.3";

  src = fetchurl {
    name = "${name}.tar.gz";
    url = "mirror://sourceforge/xml-copy-editor/${name}.tar.gz";
    sha256 = "0bwxn89600jbrkvlwyawgc0c0qqxpl453mbgcb9qbbxl8984ns4v";
  };

  patches = [ ./xmlcopyeditor.patch ];
  CPLUS_INCLUDE_PATH = "${libxml2.dev}/include/libxml2";

  nativeBuildInputs = [ intltool ];
  buildInputs = [ aspell boost expat libxml2 libxslt pcre wxGTK xercesc ];

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    description = "A fast, free, validating XML editor";
    homepage = http://xml-copy-editor.sourceforge.net/;
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
    maintainers = with maintainers; [ candeira ];
  };
}
