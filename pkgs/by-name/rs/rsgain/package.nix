{
  lib,
  stdenv,
  fetchFromGitHub,
  pkg-config,
  cmake,
  libebur128,
  taglib,
  ffmpeg,
  inih,
  fmt,
  zlib,
}:

stdenv.mkDerivation rec {
  pname = "rsgain";
  version = "3.6";

  src = fetchFromGitHub {
    owner = "complexlogic";
    repo = "rsgain";
    rev = "v${version}";
    hash = "sha256-dqvaPLVpNnbN2W0TOphS7QU6MDh5pxFJoUDGvkat164=";
  };

  nativeBuildInputs = [
    pkg-config
    cmake
  ];
  buildInputs = [
    libebur128
    taglib
    ffmpeg
    inih
    fmt
    zlib
  ];

  meta = {
    description = "Simple, but powerful ReplayGain 2.0 tagging utility";
    mainProgram = "rsgain";
    homepage = "https://github.com/complexlogic/rsgain";
    changelog = "https://github.com/complexlogic/rsgain/blob/v${version}/CHANGELOG";
    license = lib.licenses.bsd2;
    platforms = lib.platforms.all;
    maintainers = [ lib.maintainers.felipeqq2 ];
  };
}
