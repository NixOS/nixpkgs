{ stdenv, fetchFromGitHub, ncurses, asciidoc, xmlto, docbook_xsl, docbook_xml_dtd_45
, readline, makeWrapper, git, libiconv, autoreconfHook, findXMLCatalogs, pkgconfig
}:

stdenv.mkDerivation rec {
  pname = "tig";
  version = "2.2.2";
  name = "${pname}-${version}";

  src = fetchFromGitHub {
    owner = "jonas";
    repo = pname;
    rev = name;
    sha256 = "1zbj4pfcnj1d0zfhx5jw9x7f2hz99mry20bgyyvrij2vj8gf5vk4";
  };

  nativeBuildInputs = [ makeWrapper autoreconfHook asciidoc xmlto docbook_xsl docbook_xml_dtd_45 findXMLCatalogs pkgconfig ];

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
    homepage = https://jonas.github.io/tig/;
    description = "Text-mode interface for git";
    maintainers = with maintainers; [ garbas bjornfor domenkozar qknight ];
    license = licenses.gpl2;
    platforms = platforms.unix;
  };
}
