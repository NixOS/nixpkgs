{
  stdenv,
  lib,
  fetchFromGitHub,
  cmake,
  flac,
  libpulseaudio,
  libsForQt5,
  makeWrapper,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "noson";
  version = "5.6.13";

  src = fetchFromGitHub {
    owner = "janbar";
    repo = "noson-app";
    tag = finalAttrs.version;
    hash = "sha256-XJBkPhyDPeyVrcY5Q5W9LtESuVxcbcQ8JoyOzKg+0NU=";
  };

  nativeBuildInputs = [
    cmake
    libsForQt5.wrapQtAppsHook
    makeWrapper
  ];

  buildInputs = [
    flac
    libpulseaudio
    libsForQt5.qtbase
    libsForQt5.qtgraphicaleffects
    libsForQt5.qtquickcontrols2
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    libsForQt5.qtwayland
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
    platforms = with lib.platforms; linux ++ darwin;
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ callahad ];
  };
})
