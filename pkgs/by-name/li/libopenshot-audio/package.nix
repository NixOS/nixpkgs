{
  lib,
  stdenv,
  fetchFromGitHub,
  alsa-lib,
  cmake,
  doxygen,
  libx11,
  libxcursor,
  libxext,
  libxft,
  libxinerama,
  libxrandr,
  pkg-config,
  zlib,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libopenshot-audio";
  version = "0.6.0";

  src = fetchFromGitHub {
    owner = "OpenShot";
    repo = "libopenshot-audio";
    rev = "v${finalAttrs.version}";
    hash = "sha256-NfwjyX+9OiS4NoB4ubscNF52kF4i3GAVjb4Z/RwkaCI=";
  };

  nativeBuildInputs = [
    cmake
    doxygen
    pkg-config
  ];

  buildInputs =
    lib.optionals stdenv.hostPlatform.isLinux [
      alsa-lib
    ]
    ++ (
      if stdenv.hostPlatform.isDarwin then
        [
          zlib
        ]
      else
        [
          libx11
          libxcursor
          libxext
          libxft
          libxinerama
          libxrandr
        ]
    );

  strictDeps = true;
  __structuredAttrs = true;

  doCheck = true;

  meta = {
    homepage = "http://openshot.org/";
    description = "High-quality sound editing library";
    mainProgram = "openshot-audio-demo";
    longDescription = ''
      OpenShot Audio Library (libopenshot-audio) is a program that allows the
      high-quality editing and playback of audio, and is based on the amazing
      JUCE library.
    '';
    license = with lib.licenses; [ gpl3Plus ];
    maintainers = [ ];
    platforms = lib.platforms.unix;
  };
})
