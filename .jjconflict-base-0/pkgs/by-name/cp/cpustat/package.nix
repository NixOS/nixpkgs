{
  lib,
  stdenv,
  fetchFromGitHub,
  ncurses,
}:

stdenv.mkDerivation rec {
  pname = "cpustat";
  version = "0.03.00";

  src = fetchFromGitHub {
    owner = "ColinIanKing";
    repo = "cpustat";
    tag = "V${version}";
    hash = "sha256-wvCaMmWKEzanwgDBL2+8qAIIIKfGNi0O2J+SUXOx508=";
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
