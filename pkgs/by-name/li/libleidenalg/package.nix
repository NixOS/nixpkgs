{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  igraph,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libleidenalg";
  version = "0.12.0";

  src = fetchFromGitHub {
    owner = "vtraag";
    repo = "libleidenalg";
    tag = finalAttrs.version;
    hash = "sha256-ptfX31/1cUHLluc+Y+g28s4BEoGC0LqC9HH0cpkJRJQ=";
  };

  nativeBuildInputs = [
    cmake
  ];

  buildInputs = [
    igraph
  ];

  meta = {
    changelog = "https://github.com/vtraag/libleidenalg/blob/${finalAttrs.src.tag}/CHANGELOG";
    description = "C++ library of Leiden algorithm";
    homepage = "https://github.com/vtraag/libleidenalg";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ dotlambda ];
    platforms = lib.platforms.all;
  };
})
