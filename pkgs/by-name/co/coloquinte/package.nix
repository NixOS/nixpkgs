{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  lemon-graph,
  eigen,
  boost,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "coloquinte";
  version = "0.3.1";

  src = fetchFromGitHub {
    owner = "coloquinte";
    repo = "PlaceRoute";
    rev = finalAttrs.version;
    hash = "sha256-bPDXaNZCNBM0qiu+46cL/zH/41lwqHPqfqTzJaERgVQ=";
  };

  nativeBuildInputs = [
    cmake
  ];

  buildInputs = [
    lemon-graph
    eigen
    boost
  ];

  meta = {
    description = "Placement library for electronic circuits";
    homepage = "https://github.com/Coloquinte/PlaceRoute";
    license = lib.licenses.mit;
    platforms = lib.platforms.linux;
    maintainers = [ lib.maintainers.coloquinte ];
  };
})
