{ config
, lib
, stdenv
, fetchFromGitHub
, cmake
, codec2
, libpulseaudio
, libsamplerate
, libsndfile
, lpcnetfreedv
, portaudio
, speexdsp
, hamlib
, wxGTK32
, pulseSupport ? config.pulseaudio or stdenv.isLinux
, AppKit
, AVFoundation
, Cocoa
, CoreMedia
}:

stdenv.mkDerivation rec {
  pname = "freedv";
  version = "1.8.4";

  src = fetchFromGitHub {
    owner = "drowe67";
    repo = "freedv-gui";
    rev = "v${version}";
    hash = "sha256-X/jL6q2yLNtRq7Xg9JeXu1zXD0KCs59D1poA9hM3Ndo=";
  };

  postPatch = lib.optionalString stdenv.isDarwin ''
    substituteInPlace src/CMakeLists.txt \
      --replace "if(APPLE)" "if(0)" \
      --replace "\''${FREEDV_LINK_LIBS})" "\''${FREEDV_LINK_LIBS} \''${FREEDV_LINK_LIBS_OSX})" \
      --replace "\''${RES_FILES})" "\''${RES_FILES} \''${FREEDV_SOURCES_OSX})"
  '';

  nativeBuildInputs = [ cmake ];

  buildInputs = [
    codec2
    libsamplerate
    libsndfile
    lpcnetfreedv
    speexdsp
    hamlib
    wxGTK32
  ] ++ (if pulseSupport then [ libpulseaudio ] else [ portaudio ])
  ++ lib.optionals stdenv.isDarwin [
    AppKit
    AVFoundation
    Cocoa
    CoreMedia
  ];

  cmakeFlags = [
    "-DUSE_INTERNAL_CODEC2:BOOL=FALSE"
    "-DUSE_STATIC_DEPS:BOOL=FALSE"
    "-DUNITTEST=ON"
  ] ++ lib.optionals pulseSupport [ "-DUSE_PULSEAUDIO:BOOL=TRUE" ];

  NIX_CFLAGS_COMPILE = lib.optionals (stdenv.isDarwin && stdenv.isx86_64) [
    "-DAPPLE_OLD_XCODE"
  ];

  doCheck = true;

  meta = with lib; {
    homepage = "https://freedv.org/";
    description = "Digital voice for HF radio";
    license = licenses.lgpl21;
    maintainers = with maintainers; [ mvs wegank ];
    platforms = platforms.unix;
  };
}
