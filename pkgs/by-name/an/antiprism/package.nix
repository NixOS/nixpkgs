{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
  libx11,
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
    tag = finalAttrs.version;
    hash = "sha256-0FkaIsZixYHP45H0gytnzlpRvNd8mMYjW22w15z3RH8=";
  };

  nativeBuildInputs = [ autoreconfHook ];

  buildInputs = [
    libx11
    libGLU
    libGL
    libglut
  ];

  meta = {
    homepage = "https://www.antiprism.com";
    description = "Collection of programs for generating, manipulating, transforming and viewing polyhedra";
    license = with lib.licenses; [ mit ];
    maintainers = [ ];
  };
})
