{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  kdePackages,
  glib,
  libnotify,
  libpulseaudio,
  pkg-config,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "pa-notify";
  version = "1.6.1";

  src = fetchFromGitHub {
    owner = "ikrivosheev";
    repo = "pa-notify";
    rev = "v${finalAttrs.version}";
    hash = "sha256-8wWRW92UyYQOHlE8WK6NR6xQ6qtrwPIakr0Df+dvzm0=";
  };

  nativeBuildInputs = [
    cmake
    kdePackages.extra-cmake-modules
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
