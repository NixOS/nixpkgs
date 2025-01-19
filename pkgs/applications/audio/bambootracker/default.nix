{
  stdenv,
  lib,
  fetchFromGitHub,
  gitUpdater,
  pkg-config,
  qmake,
  qt5compat ? null,
  qtbase,
  qttools,
  qtwayland,
  rtaudio_6,
  rtmidi,
  wrapQtAppsHook,
}:

assert lib.versionAtLeast qtbase.version "6.0" -> qt5compat != null;

stdenv.mkDerivation (finalAttrs: {
  pname = "bambootracker";
  version = "0.6.4";

  src = fetchFromGitHub {
    owner = "BambooTracker";
    repo = "BambooTracker";
    rev = "v${finalAttrs.version}";
    fetchSubmodules = true;
    hash = "sha256-tFUliKR55iZybNyYIF1FXh8RGf8jKEsGrWBuldB277g=";
  };

  postPatch = lib.optionalString (lib.versionAtLeast qtbase.version "6.0") ''
    # Work around lrelease finding in qmake being broken by using pre-Qt5.12 code path
    # https://github.com/NixOS/nixpkgs/issues/214765
    substituteInPlace BambooTracker/lang/lang.pri \
      --replace 'equals(QT_MAJOR_VERSION, 5):lessThan(QT_MINOR_VERSION, 12)' 'if(true)'
  '';

  nativeBuildInputs = [
    pkg-config
    qmake
    qttools
    wrapQtAppsHook
  ];

  buildInputs =
    [
      qtbase
      rtaudio_6
      rtmidi
    ]
    ++ lib.optionals stdenv.hostPlatform.isLinux [
      qtwayland
    ]
    ++ lib.optionals (lib.versionAtLeast qtbase.version "6.0") [
      qt5compat
    ];

  qmakeFlags =
    [
      "CONFIG+=system_rtaudio"
      "CONFIG+=system_rtmidi"
    ]
    ++ lib.optionals (stdenv.cc.isClang || (lib.versionAtLeast qtbase.version "6.0")) [
      # Clang is extra-strict about some deprecations
      # Latest Qt6 deprecated QCheckBox::stateChanged(int)
      "CONFIG+=no_warnings_are_errors"
    ];

  postConfigure = "make qmake_all";

  # Wrapping the inside of the app bundles, avoiding double-wrapping
  dontWrapQtApps = stdenv.hostPlatform.isDarwin;

  postInstall = lib.optionalString stdenv.hostPlatform.isDarwin ''
    mkdir -p $out/Applications
    mv $out/{bin,Applications}/BambooTracker.app
    ln -s $out/{Applications/BambooTracker.app/Contents/MacOS,bin}/BambooTracker
    wrapQtApp $out/Applications/BambooTracker.app/Contents/MacOS/BambooTracker
  '';

  passthru = {
    updateScript = gitUpdater {
      rev-prefix = "v";
    };
  };

  meta = with lib; {
    description = "Tracker for YM2608 (OPNA) which was used in NEC PC-8801/9801 series computers";
    mainProgram = "BambooTracker";
    homepage = "https://bambootracker.github.io/BambooTracker/";
    license = licenses.gpl2Plus;
    platforms = platforms.all;
    maintainers = with maintainers; [ OPNA2608 ];
  };
})
