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
  version = "1.6.12";

  src = fetchFromGitHub {
    owner = "4ti2";
    repo = "4ti2";
    rev = "Release_${builtins.replaceStrings [ "." ] [ "_" ] finalAttrs.version}";
    hash = "sha256-B01KfZUlG50qCjVLy8+nql8AR+exNMLDWHGhTDhOpg0=";
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
    maintainers = with lib.maintainers; [ ];
    platforms = lib.platforms.all;
  };
})
