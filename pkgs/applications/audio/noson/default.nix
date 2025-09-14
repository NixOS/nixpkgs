{
  stdenv,
  lib,
  fetchFromGitHub,
  cmake,
  flac,
  libpulseaudio,
  qtbase,
  qtgraphicaleffects,
  qtquickcontrols2,
  qtwayland,
  wrapQtAppsHook,
  makeWrapper,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "noson";
  version = "5.6.13";

  src = fetchFromGitHub {
    owner = "janbar";
    repo = "noson-app";
    rev = finalAttrs.version;
    hash = "sha256-XJBkPhyDPeyVrcY5Q5W9LtESuVxcbcQ8JoyOzKg+0NU=";
  };

  nativeBuildInputs = [
    cmake
    wrapQtAppsHook
    makeWrapper
  ];

  buildInputs = [
    flac
    libpulseaudio
    qtbase
    qtgraphicaleffects
    qtquickcontrols2
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    qtwayland
  ];

  # wrapQtAppsHook doesn't automatically find noson-gui
  dontWrapQtApps = true;

  preFixup = ''
    wrapProgram "$out/bin/noson-app" --prefix LD_LIBRARY_PATH : ${lib.makeLibraryPath [ libpulseaudio ]}
    wrapQtApp "$out/lib/noson/noson-gui"
  '';

  meta = {
    description = "SONOS controller for Linux (and macOS)";
    homepage = "https://janbar.github.io/noson-app/";
    mainProgram = "noson-app";
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
    license = [ lib.licenses.gpl3Only ];
    maintainers = with lib.maintainers; [ callahad ];
  };
})
