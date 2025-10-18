{
  stdenv,
  lib,
  fetchFromGitHub,
  cmake,
  gtest,
  tinycmmc,
}:

stdenv.mkDerivation {
  pname = "strutcpp";
  version = "0-unstable-2025-07-21";

  src = fetchFromGitHub {
    owner = "Grumbel";
    repo = "strutcpp";
    rev = "3c9cbf6cd0e09b34e464a0ff01aca99290d79870";
    sha256 = "sha256-pyLNbjvhGjEOGcj4Krtcm/Rms2rvBfWD1lqrEmm7gnI=";
  };

  nativeBuildInputs = [ cmake ];
  buildInputs = [
    gtest
    tinycmmc
  ];

  cmakeFlags = [
    "-DBUILD_TESTS=ON"
  ];

  doCheck = true;

  meta = {
    description = "Collection of string utilities";
    maintainers = [ lib.maintainers.SchweGELBin ];
    platforms = lib.platforms.linux;
    license = lib.licenses.free;
  };
}
