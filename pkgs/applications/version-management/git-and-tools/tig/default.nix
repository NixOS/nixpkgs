{ stdenv, fetchFromGitHub, ncurses, asciidoc, xmlto, docbook_xsl, docbook_xml_dtd_45
, readline, makeWrapper, git, libiconv, autoreconfHook, findXMLCatalogs
}:

stdenv.mkDerivation rec {
  pname = "tig";
  version = "2.2.1";
  name = "${pname}-${version}";

  src = fetchFromGitHub {
    owner = "jonas";
    repo = pname;
    rev = name;
    sha256 = "09xiwm57df0vzk8r2hx5p1hwy5f9q8frmdf96aba2ia9837zn3av";
  };

  nativeBuildInputs = [ makeWrapper autoreconfHook asciidoc xmlto docbook_xsl docbook_xml_dtd_45 findXMLCatalogs ];

  autoreconfFlags = "-I tools -v";

  buildInputs = [ ncurses readline git ]
    ++ stdenv.lib.optionals stdenv.isDarwin [ libiconv ];

  # those files are inherently impure, we'll handle the corresponding dependencies.
  postPatch = ''
      rm -f contrib/config.make-*
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
