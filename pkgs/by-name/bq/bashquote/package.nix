{
  lib,
  stdenv,
  fetchFromGitHub,
  makeWrapper,
  coreutils,
  ncurses,
  gnugrep,
  gawk,
  gnused,
}:

stdenv.mkDerivation rec {

  pname = "bashquote";
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "harbiinger";
    repo = "bashquote";
    tag = version;
    hash = "sha256-B3cnFairWgdQ6PmXVlEOhSA/nJGkIhv9/7/i6bKSzf4=";
  };

  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    mkdir -p $out/bin
    mkdir -p $out/share/bashquote/quotes

    cp -r quotes/* $out/share/bashquote/quotes/

    cp bashquote $out/bin/bashquote
    chmod +x $out/bin/bashquote

    wrapProgram $out/bin/bashquote \
      --prefix PATH : ${
        lib.makeBinPath [
          coreutils
          ncurses
          gnugrep
          gawk
          gnused
        ]
      }
  '';

  meta = with lib; {
    description = "Print a quote when you open a terminal";
    mainProgram = "bashquote";
    maitnainers = with maintainers; [ harbiinger ];
    license = licenses.gpl3;
  };

}

