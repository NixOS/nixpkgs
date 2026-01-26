{
  stdenv,
  fetchFromGitHub,
  cmake,
  pkg-config,
  wrapQtAppsHook,
  lib,
  qttools,
  fribidi,
  libunibreak,
  zstd,
}:

stdenv.mkDerivation rec {
  pname = "coolreader";
  version = "3.2.58";

  src = fetchFromGitHub {
    owner = "buggins";
    repo = "coolreader";
    rev = "cr${version}";
    sha256 = "sha256-DUcYUFxPPSPvoEUEbKYEAGxFeFGQCfOFA0+SegoC4oI=";
  };

  patches = [ ./cmake_policy_version_3_5.patch ];

  nativeBuildInputs = [
    cmake
    pkg-config
    wrapQtAppsHook
  ];

  buildInputs = [
    qttools
    fribidi
    libunibreak
    zstd
  ];

  meta = {
    broken = stdenv.hostPlatform.isDarwin;
    homepage = "https://github.com/buggins/coolreader";
    description = "Cross platform open source e-book reader";
    mainProgram = "cr3";
    license = lib.licenses.gpl2Plus; # see https://github.com/buggins/coolreader/issues/80
    maintainers = [ ];
    platforms = lib.platforms.all;
  };
}
