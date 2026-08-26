{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  igraph,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libleidenalg";
  version = "0.13.0";

  src = fetchFromGitHub {
    owner = "vtraag";
    repo = "libleidenalg";
    tag = finalAttrs.version;
    hash = "sha256-27n8Wdzu0H2Fym3aiZkE+16dgrkSK59+YWOfs+iPzI8=";
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
