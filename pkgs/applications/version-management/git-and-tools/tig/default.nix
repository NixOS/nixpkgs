{ stdenv, fetchurl, ncurses, asciidoc, xmlto, docbook_xsl, docbook_xml_dtd_45 }:

stdenv.mkDerivation rec {
  name = "tig-1.2.1";

  src = fetchurl {
    url = "http://jonas.nitro.dk/tig/releases/${name}.tar.gz";
    sha256 = "0i19lc6dd3vdpkdd8q07xii2c4mcpiwmg55av81jyhx0y82x425p";
  };

  buildInputs = [ ncurses asciidoc xmlto docbook_xsl ];

  preConfigure = ''
    export XML_CATALOG_FILES='${docbook_xsl}/xml/xsl/docbook/catalog.xml ${docbook_xml_dtd_45}/xml/dtd/docbook/catalog.xml'
  '';

  installPhase = ''
    make install
    make install-doc
    mkdir -p $out/etc/bash_completion.d/
    cp contrib/tig-completion.bash $out/etc/bash_completion.d/
  '';

  meta = with stdenv.lib; {
    homepage = "http://jonas.nitro.dk/tig/";
    description = "Text-mode interface for git";
    maintainers = with maintainers; [ garbas bjornfor iElectric ];
    license = licenses.gpl2;
    platforms = platforms.linux;
  };
}
