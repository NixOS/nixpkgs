{ stdenv, fetchurl, ncurses, asciidoc, xmlto, docbook_xsl, docbook_xml_dtd_45
, readline, makeWrapper, git, libiconv
}:

stdenv.mkDerivation rec {
  name = "tig-2.1.1";

  src = fetchurl {
    url = "http://jonas.nitro.dk/tig/releases/${name}.tar.gz";
    sha256 = "0bw5wivswwh7vx897q8xc2cqgkqhdzk8gh6fnav2kf34sngigiah";
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
    homepage = "http://jonas.nitro.dk/tig/";
    description = "Text-mode interface for git";
    maintainers = with maintainers; [ garbas bjornfor domenkozar qknight ];
    license = licenses.gpl2;
    platforms = platforms.unix;
  };
}
