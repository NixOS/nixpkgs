{ stdenv
, lib
, fetchFromGitHub
, cmake
, flac
, libpulseaudio
, qtbase
, qtgraphicaleffects
, qtquickcontrols2
, wrapQtAppsHook
, makeWrapper
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "noson";
  version = "5.6.0";

  src = fetchFromGitHub {
    owner = "janbar";
    repo = "noson-app";
    rev = finalAttrs.version;
    hash = "sha256-ZOAnH7pdhlTbqHOM0kiCWcHYJvnskigWdz3N9WjtM0M=";
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
  ];

  # wrapQtAppsHook doesn't automatically find noson-gui
  dontWrapQtApps = true;

  preFixup = ''
    wrapProgram "$out/bin/noson-app" --prefix LD_LIBRARY_PATH : ${lib.makeLibraryPath [ libpulseaudio ]}
    wrapQtApp "$out/lib/noson/noson-gui"
  '';

  meta = with lib; {
    description = "SONOS controller for Linux (and macOS)";
    homepage = "https://janbar.github.io/noson-app/";
    mainProgram = "noson-app";
    platforms = platforms.linux ++ platforms.darwin;
    license = [ licenses.gpl3Only ];
    maintainers = with maintainers; [ callahad ];
  };
})
