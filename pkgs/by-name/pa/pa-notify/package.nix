{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  extra-cmake-modules,
  glib,
  libnotify,
  libpulseaudio,
  pkg-config,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "pa-notify";
  version = "1.5.0";

  src = fetchFromGitHub {
    owner = "ikrivosheev";
    repo = "pa-notify";
    rev = "v${finalAttrs.version}";
    hash = "sha256-356qwSxxxAUNJajsVjH3zqGAZQwMOcoLPSKPZdsCmBM=";
  };

  nativeBuildInputs = [
    cmake
    extra-cmake-modules
    pkg-config
  ];

  buildInputs = [
    glib
    libnotify
    libpulseaudio
  ];

  meta = {
    homepage = "https://github.com/ikrivosheev/pa-notify";
    description = "PulseAudio or PipeWire volume notification";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ juancmuller ];
    mainProgram = "pa-notify";
    platforms = lib.platforms.linux;
  };
})
