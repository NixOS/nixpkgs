{ stdenv, fetchurl, ncurses, asciidoc, xmlto, docbook_xsl, docbook_xml_dtd_45
, readline, makeWrapper, git, libiconv
}:

stdenv.mkDerivation rec {
  name = "tig-2.2.1";

  src = fetchurl {
    url = "https://github.com/jonas/tig/releases/download/${name}/${name}.tar.gz";
    sha256 = "0wgsqdly3jd9c7b0ibb5vwsv4js19c5hi0698nf1fnfyjq40hj0b";
  };

  buildInputs = [ ncurses asciidoc xmlto docbook_xsl readline git makeWrapper ]
    ++ stdenv.lib.optionals stdenv.isDarwin [ libiconv ];

  preConfigure = ''
    export XML_CATALOG_FILES='${docbook_xsl}/xml/xsl/docbook/catalog.xml ${docbook_xml_dtd_45}/xml/dtd/docbook/catalog.xml'
  '';

  enableParallelBuilding = true;

  installPhase = ''
    make install
    make install-doc
    mkdir -p $out/etc/bash_completion.d/
    cp contrib/tig-completion.bash $out/etc/bash_completion.d/

    wrapProgram $out/bin/tig \
      --prefix PATH ':' "${git}/bin"
  '';

  meta = with stdenv.lib; {
    homepage = "https://jonas.github.io/tig/";
    description = "Text-mode interface for git";
    maintainers = with maintainers; [ garbas bjornfor domenkozar qknight ];
    license = licenses.gpl2;
    platforms = platforms.unix;
  };
}
