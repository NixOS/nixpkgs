{
  lib,
  fetchFromGitHub,
  fetchpatch,
  cmake,
  pkg-config,
  alsa-lib ? null,
  carla ? null,
  fftwFloat,
  fltk13,
  fluidsynth ? null,
  lame ? null,
  libgig ? null,
  libjack2 ? null,
  libpulseaudio ? null,
  libsamplerate,
  libsoundio ? null,
  libsndfile,
  libvorbis ? null,
  portaudio ? null,
  qtbase,
  qtx11extras,
  qttools,
  SDL ? null,
  mkDerivation,
}:

mkDerivation rec {
  pname = "lmms";
  version = "1.2.2";

  src = fetchFromGitHub {
    owner = "LMMS";
    repo = "lmms";
    rev = "v${version}";
    sha256 = "006hwv1pbh3y5whsxkjk20hsbgwkzr4dawz43afq1gil69y7xpda";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [
    cmake
    qttools
    pkg-config
  ];

  buildInputs = [
    carla
    alsa-lib
    fftwFloat
    fltk13
    fluidsynth
    lame
    libgig
    libjack2
    libpulseaudio
    libsamplerate
    libsndfile
    libsoundio
    libvorbis
    portaudio
    qtbase
    qtx11extras
    SDL # TODO: switch to SDL2 in the next version
  ];

  patches = [
    (fetchpatch {
      url = "https://raw.githubusercontent.com/archlinux/svntogit-community/cf64acc45e3264c6923885867e2dbf8b7586a36b/trunk/lmms-carla-export.patch";
      sha256 = "sha256-wlSewo93DYBN2PvrcV58dC9kpoo9Y587eCeya5OX+j4=";
    })
  ];

  prePatch = ''
    # Update CMake minimum required version and policies
    substituteInPlace CMakeLists.txt --replace 'CMAKE_MINIMUM_REQUIRED(VERSION 2.8.7)' 'CMAKE_MINIMUM_REQUIRED(VERSION 3.10)'
    substituteInPlace CMakeLists.txt --replace 'CMAKE_POLICY(SET CMP0026 OLD)' 'CMAKE_POLICY(SET CMP0026 NEW)'
    substituteInPlace CMakeLists.txt --replace 'CMAKE_POLICY(SET CMP0050 OLD)' 'CMAKE_POLICY(SET CMP0050 NEW)'
    substituteInPlace CMakeLists.txt --replace 'GET_TARGET_PROPERTY(BIN2RES bin2res LOCATION)' 'SET(BIN2RES $<TARGET_FILE:bin2res>)'
  '';

  cmakeFlags = [
    "-DWANT_QT5=ON"
  ]
  ++ lib.optionals (lib.versionOlder version "11.4") [
    # Fix the build with CMake 4.
    "-DCMAKE_POLICY_VERSION_MINIMUM=3.5"
  ];

  meta = with lib; {
    description = "DAW similar to FL Studio (music production software)";
    mainProgram = "lmms";
    homepage = "https://lmms.io";
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
    maintainers = [ ];
  };
}
