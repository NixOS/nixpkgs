{ lib, stdenv, fetchFromGitHub, autoreconfHook }:

stdenv.mkDerivation rec {
  pname = "par2cmdline-turbo";
  version = "1.2.0";

  src = fetchFromGitHub {
    owner = "animetosho";
    repo = "par2cmdline-turbo";
    rev = "v${version}";
    hash = "sha256-GFMFqHiKoQByD8ZYgGm36ehfMP4CvC2F+u2Va20RSNI=";
  };

  nativeBuildInputs = [ autoreconfHook ];
  enableParallelBuilding = true;

  meta = {
    homepage = "https://github.com/animetosho/par2cmdline-turbo";
    description = "par2cmdline × ParPar: speed focused par2cmdline fork";
    license = lib.licenses.gpl2Plus;
    maintainers = [ lib.maintainers.proglottis ];
    platforms = lib.platforms.all;
    mainProgram = "par2";
  };
}
