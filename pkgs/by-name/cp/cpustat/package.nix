{
  lib,
  stdenv,
  fetchFromGitHub,
  ncurses,
}:

stdenv.mkDerivation rec {
  pname = "cpustat";
  version = "0.02.21";

  src = fetchFromGitHub {
    owner = "ColinIanKing";
    repo = "cpustat";
    rev = "refs/tags/V${version}";
    hash = "sha256-Rxoj2pnQ/tEUzcsFT1F+rU960b4Th3hqZU2YR6YGwZQ=";
  };

  buildInputs = [
    ncurses
  ];

  installFlags = [
    "BINDIR=${placeholder "out"}/bin"
    "MANDIR=${placeholder "out"}/share/man/man8"
    "BASHDIR=${placeholder "out"}/share/bash-completion/completions"
  ];

  meta = with lib; {
    description = "CPU usage monitoring tool";
    homepage = "https://github.com/ColinIanKing/cpustat";
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
    maintainers = [ ];
    mainProgram = "cpustat";
  };
}
