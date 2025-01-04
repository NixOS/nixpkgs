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

  # workaround for vendored GCC 3.5 <complex>
  # https://gitlab.com/sagemath/lcalc/-/issues/16
  env.NIX_CFLAGS_COMPILE = toString [
    "-D_GLIBCXX_COMPLEX"
    "-D_LIBCPP_COMPLEX"
    "-D_LIBCPP___FWD_COMPLEX_H"
  ];

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

  meta = with lib; {
    homepage = "https://gitlab.com/sagemath/lcalc";
    description = "Program for calculating with L-functions";
    mainProgram = "lcalc";
    license = with licenses; [ gpl2 ];
    maintainers = teams.sage.members;
    platforms = platforms.all;
  };
}
