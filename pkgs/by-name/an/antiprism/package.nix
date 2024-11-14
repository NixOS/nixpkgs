{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
  libX11,
  libGL,
  libGLU,
  libglut,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "antiprism";
  version = "0.32";

  src = fetchFromGitHub {
    owner = "antiprism";
    repo = "antiprism";
    rev = "refs/tags/${finalAttrs.version}";
    hash = "sha256-0FkaIsZixYHP45H0gytnzlpRvNd8mMYjW22w15z3RH8=";
  };

  nativeBuildInputs = [ autoreconfHook ];

  buildInputs = [
    libX11
    libGLU
    libGL
    libglut
  ];

  meta = with lib; {
    homepage = "https://www.antiprism.com";
    description = "Collection of programs for generating, manipulating, transforming and viewing polyhedra";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ AndersonTorres ];
  };
})
