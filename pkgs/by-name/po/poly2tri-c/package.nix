{
  lib,
  stdenv,
  fetchFromGitLab,
  autoreconfHook,
  pkg-config,
  glib,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "poly2tri-c";
  version = "0.1.0";

  outputs = [
    "bin"
    "out"
    "dev"
  ];

  src = fetchFromGitLab {
    domain = "gitlab.gnome.org";
    owner = "jtojnar";
    repo = "poly2tri-c";
    rev = "p2tc-${finalAttrs.version}";
    hash = "sha256-6AHII8OgV61e5uXPUTFGw1u5ab6E4UnOEkJ3h/moG5U=";
  };

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
  ];

  buildInputs = [
    glib
  ];

  env.NIX_CFLAGS_COMPILE = toString [
    "--std=gnu99"
    "-Wno-error"
  ];

  meta = {
    description = "Library for generating, refining and rendering 2-Dimensional Constrained Delaunay Triangulations";
    mainProgram = "p2tc";
    homepage = "https://code.google.com/archive/p/poly2tri-c/";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ jtojnar ];
    platforms = lib.platforms.unix;
  };
})
