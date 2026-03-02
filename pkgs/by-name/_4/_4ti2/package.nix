{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
  glpk,
  gmp,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "4ti2";
  version = "1.6.14";

  src = fetchFromGitHub {
    owner = "4ti2";
    repo = "4ti2";
    tag = "Release_${builtins.replaceStrings [ "." ] [ "_" ] finalAttrs.version}";
    hash = "sha256-bFvq90hLLGty7p6NLxOARVvKdizg3bp2NkP9nZpVFzQ=";
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
})
