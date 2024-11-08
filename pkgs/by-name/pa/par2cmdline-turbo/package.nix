{ lib, stdenv, fetchFromGitHub, autoreconfHook }:

stdenv.mkDerivation rec {
  pname = "par2cmdline-turbo";
  version = "1.1.1";

  src = fetchFromGitHub {
    owner = "animetosho";
    repo = "par2cmdline-turbo";
    rev = "v${version}";
    hash = "sha256-EJ6gBja5tPrfsfbqYs8pZDEPmJ6mCPfkUYOTTMFaKG8=";
  };

  nativeBuildInputs = [ autoreconfHook ];
  enableParallelBuilding = true;

  meta = with lib; {
    homepage = "https://github.com/animetosho/par2cmdline-turbo";
    description = "par2cmdline × ParPar: speed focused par2cmdline fork";
    license = licenses.gpl2Plus;
    maintainers = [ maintainers.proglottis ];
    platforms = platforms.all;
    mainProgram = "par2";
  };
}
