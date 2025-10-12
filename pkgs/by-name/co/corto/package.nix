{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
}:

stdenv.mkDerivation {
  pname = "corto";
  version = "2025.07-unstable-2025-09-22";

  src = fetchFromGitHub {
    owner = "cnr-isti-vclab";
    repo = "corto";
    rev = "c0c80fe9357cd4f5c3428a2fe73361a6e9ea40c3";
    hash = "sha256-ZI0Dji8pcBqRfs70a/opnYAlrnJ2wN46m2WshWvzLvA=";
  };

  nativeBuildInputs = [ cmake ];

  meta = with lib; {
    description = "Mesh compression library, designed for rendering and speed";
    homepage = "https://github.com/cnr-isti-vclab/corto";
    license = licenses.mit;
    maintainers = with maintainers; [ nim65s ];
  };
}
