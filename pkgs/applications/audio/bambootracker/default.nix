{ stdenv
, lib
, fetchFromGitHub
, pkg-config
, qmake
, qt5compat ? null
, qtbase
, qttools
, rtaudio
, rtmidi
, wrapQtAppsHook
}:

assert lib.versionAtLeast qtbase.version "6.0" -> qt5compat != null;

stdenv.mkDerivation rec {
  pname = "bambootracker";
  version = "0.6.1";

  src = fetchFromGitHub {
    owner = "BambooTracker";
    repo = "BambooTracker";
    rev = "v${version}";
    fetchSubmodules = true;
    hash = "sha256-Ymi1tjJCgStF0Rtseelq/YuTtBs2PrbF898TlbjyYUw=";
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

  buildInputs = [
    qtbase
    rtaudio
    rtmidi
  ] ++ lib.optionals (lib.versionAtLeast qtbase.version "6.0") [
    qt5compat
  ];

  qmakeFlags = [
    "CONFIG+=system_rtaudio"
    "CONFIG+=system_rtmidi"
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

  meta = with lib; {
    description = "A tracker for YM2608 (OPNA) which was used in NEC PC-8801/9801 series computers";
    homepage = "https://bambootracker.github.io/BambooTracker/";
    license = licenses.gpl2Plus;
    platforms = platforms.all;
    maintainers = with maintainers; [ OPNA2608 ];
  };
}
