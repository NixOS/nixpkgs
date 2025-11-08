{
  stdenv,
  lib,
  fetchFromGitHub,
  ncurses,
}:

stdenv.mkDerivation rec {
  pname = "eventstat";
  version = "0.06.00";

  src = fetchFromGitHub {
    owner = "ColinIanKing";
    repo = "eventstat";
    rev = "V${version}";
    hash = "sha256-lCtXILpZn1/laRnsfE5DlQQQKKvfHxOJu87SkpWKeTE=";
  };

  buildInputs = [ ncurses ];
  installFlags = [
    "BINDIR=${placeholder "out"}/bin"
    "MANDIR=${placeholder "out"}/share/man/man8"
    "BASHDIR=${placeholder "out"}/share/bash-completion/completions"
  ];

  meta = with lib; {
    description = "Simple monitoring of system events";
    mainProgram = "eventstat";
    homepage = "https://github.com/ColinIanKing/eventstat";
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
    maintainers = [ ];
  };
}
