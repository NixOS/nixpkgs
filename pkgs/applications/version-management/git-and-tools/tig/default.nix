{ stdenv, fetchFromGitHub, ncurses, asciidoc, xmlto, docbook_xsl, docbook_xml_dtd_45
, readline, makeWrapper, git, libiconv, autoreconfHook, findXMLCatalogs, pkgconfig
}:

stdenv.mkDerivation rec {
  pname = "tig";
  version = "2.5.1";

  src = fetchFromGitHub {
    owner = "jonas";
    repo = pname;
    rev = "${pname}-${version}";
    sha256 = "0wxcbfqsk8p84zizy6lf3gp5j122wrf8c7xlipki6nhcfhksn33b";
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

    # fixes tig-completion __git-complete dependency
    sed -i '1s;^;source ${git}/share/bash-completion/completions/git\n;' contrib/tig-completion.bash

    substituteInPlace contrib/tig-completion.zsh \
      --replace 'e=$(dirname ''${funcsourcetrace[1]%:*})/tig-completion.bash' "e=$out/share/bash-completion/completions/tig"

    install -D contrib/tig-completion.bash $out/share/bash-completion/completions/tig
    install -D contrib/tig-completion.zsh $out/share/zsh/site-functions/_tig
    cp contrib/vim.tigrc $out/etc/

    wrapProgram $out/bin/tig \
      --prefix PATH ':' "${git}/bin"
  '';

  meta = with stdenv.lib; {
    homepage = "https://jonas.github.io/tig/";
    description = "Text-mode interface for git";
    maintainers = with maintainers; [ bjornfor domenkozar qknight globin ];
    license = licenses.gpl2;
    platforms = platforms.unix;
  };
}
