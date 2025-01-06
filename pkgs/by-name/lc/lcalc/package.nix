{
  lib,
  stdenv,
  autoreconfHook,
  gengetopt,
  pkg-config,
  fetchFromGitLab,
  pari,
}:

stdenv.mkDerivation rec {
  version = "2.0.5";
  pname = "lcalc";

  src = fetchFromGitLab {
    owner = "sagemath";
    repo = pname;
    rev = version;
    hash = "sha256-RxWZ7T0I9zV7jUVnL6jV/PxEoU32KY7Q1UsOL5Lonuc=";
  };

  # workaround for vendored GCC <complex> on libc++
  # https://gitlab.com/sagemath/lcalc/-/issues/16
  patches = [ ./libcxx-compat.patch ];

  nativeBuildInputs = [
    autoreconfHook
    gengetopt
    pkg-config
  ];

  buildInputs = [
    pari
  ];

  configureFlags = [
    "--with-pari"
  ];

  meta = {
    homepage = "https://gitlab.com/sagemath/lcalc";
    description = "Program for calculating with L-functions";
    mainProgram = "lcalc";
    license = with lib.licenses; [ gpl2 ];
    maintainers = lib.teams.sage.members;
    platforms = lib.platforms.all;
  };
}
