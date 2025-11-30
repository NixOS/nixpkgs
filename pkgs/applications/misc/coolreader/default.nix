{
  stdenv,
  mkDerivation,
  fetchFromGitHub,
  fetchpatch,
  cmake,
  pkg-config,
  lib,
  qttools,
  fribidi,
  libunibreak,
  zstd,
}:

mkDerivation rec {
  pname = "coolreader";
  version = "3.2.58";

  src = fetchFromGitHub {
    owner = "buggins";
    repo = "coolreader";
    rev = "cr${version}";
    sha256 = "sha256-DUcYUFxPPSPvoEUEbKYEAGxFeFGQCfOFA0+SegoC4oI=";
  };

  patches = [
    (fetchpatch {
      url = "https://github.com/buggins/coolreader/commit/fc4baf7cbb71ba7a47b174870dacf0e4ec93b6bf.patch";
      hash = "sha256-CehPJ85GZXhibUZlvrYdR2M1DuZ1LTrMwvRmvaFsRb4=";
    })
  ];

  nativeBuildInputs = [
    cmake
    pkg-config
  ];

  buildInputs = [
    qttools
    fribidi
    libunibreak
    zstd
  ];

  meta = with lib; {
    broken = stdenv.hostPlatform.isDarwin;
    homepage = "https://github.com/buggins/coolreader";
    description = "Cross platform open source e-book reader";
    mainProgram = "cr3";
    license = licenses.gpl2Plus; # see https://github.com/buggins/coolreader/issues/80
    maintainers = [ ];
    platforms = platforms.all;
  };
}
