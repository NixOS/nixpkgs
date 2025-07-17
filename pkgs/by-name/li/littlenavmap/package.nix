{
  lib,
  stdenv,
  callPackage,
  fetchFromGitHub,
  libsForQt5,
  makeDesktopItem,
}:
let
  atools = callPackage ./atools.nix { };
  marble = libsForQt5.marble.overrideAttrs (self: {
    version = "0.25.5";

    src = fetchFromGitHub {
      owner = "albar965";
      repo = "marble";
      rev = "722acf7f8d79023f6c6a761063645a1470bb3935"; # branch lnm/1.1
      hash = "sha256-5GSa+xIQS9EgJXxMFUOA5jTtHJ6Dl4C9yAkFPIOrgo8=";
    };

    # https://github.com/albar965/littlenavmap/wiki/Compiling#compile-marble
    cmakeFlags =
      let
        disable = n: lib.cmakeBool n false;
        enable = n: lib.cmakeBool n true;
      in
      map enable [
        "STATIC_BUILD"
        "MARBLE_EMPTY_MAPTHEME"
        "QTONLY"
      ]
      ++ map disable [
        "BUILD_MARBLE_EXAMPLES"
        "BUILD_INHIBIT_SCREENSAVER_PLUGIN"
        "BUILD_MARBLE_APPS"
        "BUILD_MARBLE_EXAMPLES"
        "BUILD_MARBLE_TESTS"
        "BUILD_MARBLE_TOOLS"
        "BUILD_TESTING"
        "BUILD_WITH_DBUS"
        "MOBILE"
        "WITH_DESIGNER_PLUGIN"
        "WITH_Phonon"
        "WITH_Qt5Location"
        "WITH_Qt5Positioning"
        "WITH_Qt5SerialPort"
        "WITH_ZLIB"
        "WITH_libgps"
        "WITH_libshp"
        "WITH_libwlocate"
      ];
  });

  desktopItem = makeDesktopItem {
    name = "Little Navmap";
    desktopName = "Little Navmap";
    icon = "littlenavmap";
    terminal = false;
    exec = "littlenavmap";
    categories = [
      "Qt"
      "Utility"
      "Geography"
      "Maps"
    ];
  };
in
stdenv.mkDerivation (finalAttrs: {
  pname = "littlenavmap";
  version = "3.0.17";

  src = fetchFromGitHub {
    owner = "albar965";
    repo = "littlenavmap";
    tag = "v${finalAttrs.version}";
    hash = "sha256-/1YB2uEQzT0K6IylpWDqOaMSENDR9GuyJNty+2C8kXM=";
  };

  nativeBuildInputs = [
    libsForQt5.qmake
    libsForQt5.wrapQtAppsHook
  ];

  # https://github.com/albar965/littlenavmap/wiki/Compiling#default-paths-and-environment-variables-2
  env = {
    ATOOLS_INC_PATH = "${atools}/include";
    ATOOLS_LIB_PATH = "${atools}/lib";
    MARBLE_INC_PATH = "${marble.dev}/include";
    MARBLE_LIB_PATH = "${marble}/lib";
    inherit (atools) ATOOLS_NO_CRASHHANDLER;
  };

  patches = [ ./deploy.patch ];

  configurePhase = ''
    runHook preConfigure

    # we have to build out of source tree
    cd build
    qmake "''${flagsArray[@]}" ..

    runHook postConfigure
  '';

  postInstall = ''
    mkdir -p $out/bin $out/lib $out/share/icons/scaleable/apps
    mv "../../deploy/Little Navmap" $out/lib/littlenavmap
    ln -s $out/lib/littlenavmap/littlenavmap $out/bin
    cp -ra ${desktopItem}/* $out
    mv $out/lib/littlenavmap/littlenavmap.svg $out/share/icons/scaleable/apps
  '';

  enableParallelBuilding = true;
  enableParallelInstalling = true;

  installTargets = "deploy";

  passthru.local-packages = { inherit atools marble; };

  meta = {
    description = "Free flight planner, navigation tool, moving map, airport search and airport information system for Flight Simulator X, Microsoft Flight Simulator 2020, Prepar3D and X-Plane";
    homepage = "https://github.com/albar965/littlenavmap";
    changelog = "https://github.com/albar965/littlenavmap/blob/${finalAttrs.src.tag}/CHANGELOG.txt";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ ck3d ];
    mainProgram = "littlenavmap";
    platforms = lib.platforms.linux;
  };
})
