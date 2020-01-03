{ stdenv, fetchFromGitHub, ncurses, asciidoc, xmlto, docbook_xsl, docbook_xml_dtd_45, fetchpatch
, readline, makeWrapper, git, libiconv, autoreconfHook, findXMLCatalogs, pkgconfig
}:

stdenv.mkDerivation rec {
  pname = "tig";
  version = "2.5.0";

  src = fetchFromGitHub {
    owner = "jonas";
    repo = pname;
    rev = "${pname}-${version}";
    sha256 = "1lrzgnq8ywq28qd4xyd0y5qfv3j25ra81lcbdqqfywasl8lwz3lf";
  };

  nativeBuildInputs = [ makeWrapper autoreconfHook asciidoc xmlto docbook_xsl docbook_xml_dtd_45 findXMLCatalogs pkgconfig ];

  autoreconfFlags = "-I tools -v";

  buildInputs = [ ncurses readline git ]
    ++ stdenv.lib.optionals stdenv.isDarwin [ libiconv ];

  # those files are inherently impure, we'll handle the corresponding dependencies.
  postPatch = ''
      rm -f contrib/config.make-*
  '';

  patches = [
    # Fix memory leak. Remove with the next release
    (fetchpatch {
      url = "https://github.com/jonas/tig/commit/6202c6032f17438a2facb23f02e330b9d0566d9d.patch";
      sha256 = "15zn8hw9y7bqa1np4mj0qnm2z86nif7qwh7wc4vgy2rwxdil85bd";
    })
  ];

  enableParallelBuilding = true;

  installPhase = ''
    make install
    make install-doc

    substituteInPlace contrib/tig-completion.zsh \
      --replace 'e=$(dirname ''${funcsourcetrace[1]%:*})/tig-completion.bash' "e=$out/etc/bash_completion.d/tig-completion.bash"

    install -D contrib/tig-completion.bash $out/etc/bash_completion.d/tig-completion.bash
    install -D contrib/tig-completion.zsh $out/share/zsh/site-functions/_tig
    cp contrib/vim.tigrc $out/etc/

    wrapProgram $out/bin/tig \
      --prefix PATH ':' "${git}/bin"
  '';

  meta = with stdenv.lib; {
    homepage = https://jonas.github.io/tig/;
    description = "Text-mode interface for git";
    maintainers = with maintainers; [ bjornfor domenkozar qknight globin ];
    license = licenses.gpl2;
    platforms = platforms.unix;
  };
}
