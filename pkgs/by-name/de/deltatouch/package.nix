{ lib
, stdenv
, fetchFromGitea
, fetchpatch
, cmake
, intltool
, libdeltachat
, lomiri
, qt5
, quirc
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "deltatouch";
  version = "1.4.0";

  src = fetchFromGitea {
    domain = "codeberg.org";
    owner = "lk108";
    repo = "deltatouch";
    rev = "v${finalAttrs.version}";
    hash = "sha256-tqcQmFmF8Z9smVMfaXOmXQ3Uw41bUcU4iUi8fxBlg8U=";
    fetchSubmodules = true;
  };


  patches = [
    (fetchpatch {
      name = "0001-deltatouch-Fix-localisation.patch";
      url = "https://codeberg.org/lk108/deltatouch/commit/dcfdd8a0fca5fff10d0383f77f4c0cbea302de00.patch";
      hash = "sha256-RRjHG/xKtj757ZP2SY0GtWwh66kkTWoICV1vDkFAw3k=";
    })
  ];

  nativeBuildInputs = [
    qt5.wrapQtAppsHook
    intltool
    cmake
  ];

  buildInputs = [
    qt5.qtbase
    qt5.qtwebengine
    qt5.qtquickcontrols2
    lomiri.lomiri-ui-toolkit
    lomiri.lomiri-ui-extras
    lomiri.lomiri-api
    lomiri.lomiri-indicator-network # Lomiri.Connectivity module
    lomiri.qqc2-suru-style
  ];

  postPatch = ''
    # Fix all sorts of install locations
    substituteInPlace CMakeLists.txt \
      --replace-fail 'set(DATA_DIR /)' 'set(DATA_DIR ''${CMAKE_INSTALL_DATAROOTDIR})' \
      --replace-fail 'RUNTIME DESTINATION ''${CMAKE_INSTALL_PREFIX}' 'RUNTIME DESTINATION ''${CMAKE_INSTALL_BINDIR}' \
      --replace-fail 'assets/logo.svg DESTINATION assets' 'assets/logo.svg DESTINATION ''${CMAKE_INSTALL_DATAROOTDIR}/icons/hicolor/scalable/apps RENAME deltatouch.svg' \
      --replace-fail "\''${DESKTOP_FILE_NAME} DESTINATION \''${DATA_DIR}" "\''${DESKTOP_FILE_NAME} DESTINATION \''${CMAKE_INSTALL_DATAROOTDIR}/applications"

    substituteInPlace plugins/DeltaHandler/CMakeLists.txt plugins/DTWebEngineProfile/CMakeLists.txt \
      --replace-fail 'set(QT_IMPORTS_DIR "/lib/''${ARCH_TRIPLET}")' 'set(QT_IMPORTS_DIR "${placeholder "out"}/${qt5.qtbase.qtQmlPrefix}")'

    # Fix import of library dependencies
    substituteInPlace plugins/DeltaHandler/CMakeLists.txt \
      --replace-fail 'IMPORTED_LOCATION "''${CMAKE_CURRENT_BINARY_DIR}/libdeltachat.so"' 'IMPORTED_LOCATION "${lib.getLib libdeltachat}/lib/libdeltachat.so"' \
      --replace-fail 'IMPORTED_LOCATION "''${CMAKE_CURRENT_BINARY_DIR}/libquirc.so.1.2"' 'IMPORTED_LOCATION "${lib.getLib quirc}/lib/libquirc.so"'

    # Fix icon reference in desktop file
    substituteInPlace deltatouch.desktop.in \
      --replace-fail 'Icon=assets/logo.svg' 'Icon=deltatouch'
  '';

  postInstall = ''
    # Remove clickable metadata & helpers from out
    rm $out/{manifest.json,share/push*}
  '';

  meta = with lib; {
    changelog = "https://codeberg.org/lk108/deltatouch/src/commit/${finalAttrs.src.rev}/CHANGELOG";
    description = "Messaging app for Ubuntu Touch, powered by Delta Chat core";
    longDescription = ''
      DeltaTouch is a messenger for Ubuntu Touch based on Delta Chat core.
      Delta Chat works over email.
    '';
    homepage = "https://codeberg.org/lk108/deltatouch";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ link2xt ];
    mainProgram = "deltatouch";
    platforms = platforms.linux;
  };
})
