{
  lib,
  stdenv,
  fetchFromGitLab,
  autoreconfHook,
  pkg-config,
  glib,
}:

stdenv.mkDerivation rec {
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
    repo = pname;
    rev = "p2tc-${version}";
    sha256 = "158vm3wqfxs22b74kqc4prlvjny38qqm3kz5wrgasmx0qciwh0g8";
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

  meta = with lib; {
    description = "Library for generating, refining and rendering 2-Dimensional Constrained Delaunay Triangulations";
    mainProgram = "p2tc";
    homepage = "https://code.google.com/archive/p/poly2tri-c/";
    license = licenses.bsd3;
    maintainers = with lib.maintainers; [ jtojnar ];
    platforms = platforms.unix;
  };
}
