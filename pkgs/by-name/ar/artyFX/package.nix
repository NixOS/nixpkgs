{
  lib,
  stdenv,
  fetchFromGitHub,
  cairomm,
  cmake,
  libjack2,
  libpthreadstubs,
  libXdmcp,
  libxshmfence,
  libsndfile,
  lv2,
  ntk,
  pkg-config,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "artyFX";
  version = "1.3.1";

  src = fetchFromGitHub {
    owner = "openAVproductions";
    repo = "openAV-ArtyFX";
    rev = "release-${finalAttrs.version}";
    hash = "sha256-GD9nwXdXSJX5OvAMxEAnngkvRW+E1jrNfWXK122bsTM=";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
  ];
  buildInputs = [
    cairomm
    libjack2
    libpthreadstubs
    libXdmcp
    libxshmfence
    libsndfile
    lv2
    ntk
  ];

  postPatch = ''
    substituteInPlace CMakeLists.txt --replace-fail \
      'cmake_minimum_required (VERSION 2.6)' \
      'cmake_minimum_required(VERSION 4.0)'
    substituteInPlace src/avtk/CMakeLists.txt --replace-fail \
      'cmake_minimum_required (VERSION 2.6)' \
      'cmake_minimum_required(VERSION 4.0)'
  '';

  meta = {
    homepage = "http://openavproductions.com/artyfx/";
    description = "LV2 plugin bundle of artistic realtime effects";
    license = lib.licenses.gpl2;
    maintainers = [ lib.maintainers.magnetophon ];
    platforms = lib.platforms.linux;
    # Build uses `-msse` and `-mfpmath=sse`
    badPlatforms = [ "aarch64-linux" ];
  };
})
