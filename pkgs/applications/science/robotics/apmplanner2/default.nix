{
  lib,
  stdenv,
  mkDerivation,
  fetchFromGitHub,
  qmake,
  qtbase,
  qtscript,
  qtmultimedia,
  qtserialport,
  qtsvg,
  qtdeclarative,
  qtquickcontrols2,
  alsa-lib,
  libsndfile,
  flite,
  openssl,
  udev,
  SDL2,
}:

mkDerivation rec {
  pname = "apmplanner2";
  version = "2.0.28";

  src = fetchFromGitHub {
    owner = "ArduPilot";
    repo = "apm_planner";
    rev = version;
    sha256 = "0wvbfjnnf7sh6fpgw8gimh5hgzywj3nwrgr80r782f5gayd3v2l1";
  };

  # After qmake generates the Makefile, fix bundled framework and QML references
  postConfigure = lib.optionalString stdenv.isDarwin ''
    # Remove references to bundled SDL2 framework and use nix SDL2 instead
    substituteInPlace Makefile \
      --replace-fail \
        "-F$PWD/libs/lib/Frameworks -framework SDL2" \
        "-L${lib.getLib SDL2}/lib -lSDL2" \
      --replace-fail \
        "-I$PWD/libs/lib/Frameworks/SDL2.framework/Headers" \
        "-I${lib.getDev SDL2}/include/SDL2"

    # Remove bundled framework copy command (doesn't support arm64)
    substituteInPlace Makefile \
      --replace-fail \
        "cp -f -R -L $PWD/libs/lib/Frameworks" \
        "true # skip bundled frameworks copy"

    # Remove install_name_tool command for bundled SDL2 framework
    substituteInPlace Makefile \
      --replace-fail \
        "install_name_tool -change @rpath/SDL2.framework/Versions/A/SDL2" \
        "true # skip SDL2 install_name_tool ||"

    # Fix QtQuick QML copy commands - qtdeclarative has qml dir, not qtbase
    substituteInPlace Makefile \
      --replace-fail \
        "/qml/QtQuick " \
        "/lib/qt-${qtbase.qtCompatVersion}/qml/QtQuick " \
      --replace-fail \
        "/qml/QtQuick.2 " \
        "/lib/qt-${qtbase.qtCompatVersion}/qml/QtQuick.2 "
  '';

  buildInputs = [
    qtbase
    qtscript
    qtmultimedia
    qtserialport
    qtsvg
    qtdeclarative
    qtquickcontrols2
    SDL2
  ]
  ++ lib.optionals stdenv.isLinux [
    alsa-lib
    libsndfile
    flite
    openssl
    udev
  ];

  nativeBuildInputs = [ qmake ];

  qmakeFlags = [ "apm_planner.pro" ];

  # Add SDL2 include path for Darwin
  env.NIX_CFLAGS_COMPILE = lib.optionalString stdenv.isDarwin "-I${lib.getDev SDL2}/include/SDL2";

  # Link Darwin frameworks needed by SDL2
  NIX_LDFLAGS = lib.optionalString stdenv.isDarwin (toString [
    "-L${SDL2}/lib"
    "-lSDL2"
    "-framework ApplicationServices"
    "-framework CoreAudio"
    "-framework AudioToolbox"
    "-framework CoreFoundation"
    "-framework IOKit"
  ]);

  # Post-install fixup for macOS bundle
  postInstall = lib.optionalString stdenv.isDarwin ''
    mkdir -p $out/{Applications,bin}
    cp -r release/apmplanner2.app $out/Applications
    ln -s $out/Applications/apmplanner2.app/Contents/MacOS/apmplanner2 $out/bin/apmplanner2
  '';

  # this ugly hack is necessary, as `bin/apmplanner2` needs the contents of `share/APMPlanner2` inside of `bin/`
  preFixup = lib.optionalString stdenv.isLinux ''
    ln --relative --symbolic $out/share/APMPlanner2/* $out/bin/
    substituteInPlace $out/share/applications/apmplanner2.desktop \
      --replace /usr $out
  '';

  meta = {
    description = "Ground station software for autonomous vehicles";
    longDescription = ''
      A GUI ground control station for autonomous vehicles using the MAVLink protocol.
      Includes support for the APM and PX4 based controllers.
    '';
    homepage = "https://ardupilot.org/planner2/";
    license = lib.licenses.gpl3;
    maintainers = with lib.maintainers; [ wucke13 ];
    platforms = lib.platforms.unix;
    mainProgram = "apmplanner2";
  };
}
