{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
  glpk,
  gmp,
}:

stdenv.mkDerivation rec {
  pname = "4ti2";
  version = "1.6.13";

  src = fetchFromGitHub {
    owner = "4ti2";
    repo = "4ti2";
    rev = "Release_${builtins.replaceStrings [ "." ] [ "_" ] version}";
    hash = "sha256-gbYG55LfVhjJJFJu0L8AWIAnFDViHIW2N1qtS8xOFAc=";
  };

  nativeBuildInputs = [
    autoreconfHook
  ];

  buildInputs = [
    glpk
    gmp
  ];

  installFlags = [ "install-exec" ];

  meta = {
    homepage = "https://4ti2.github.io/";
    description = "Software package for algebraic, geometric and combinatorial problems on linear spaces";
    license = lib.licenses.gpl2Plus;
    maintainers = [ ];
    platforms = lib.platforms.all;
  };
}
