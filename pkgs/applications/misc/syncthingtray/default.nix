{ mkDerivation
, lib
, stdenv
, fetchFromGitHub
, substituteAll
, qtbase
, qtwebengine
, qtdeclarative
, extra-cmake-modules
, cpp-utilities
, qtutilities
, qtforkawesome
, boost
, wrapQtAppsHook
, cmake
, kio
, plasma-framework
, qttools
, iconv
, webviewSupport ? true
, jsSupport ? true
, kioPluginSupport ? stdenv.isLinux
, plasmoidSupport  ? stdenv.isLinux
, systemdSupport ? stdenv.isLinux
/* It is possible to set via this option an absolute exec path that will be
written to the `~/.config/autostart/syncthingtray.desktop` file generated
during runtime. Alternatively, one can edit the desktop file themselves after
it is generated See:
https://github.com/NixOS/nixpkgs/issues/199596#issuecomment-1310136382 */
, autostartExecPath ? "syncthingtray"
}:

stdenv.mkDerivation (finalAttrs: {
  version = "1.4.6";
  pname = "syncthingtray";

  src = fetchFromGitHub {
    owner = "Martchus";
    repo = "syncthingtray";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-/HAqO0eVFt4YLGeTbZSZcH2pOojvykukAGTBHZTfKLQ=";
  };

  buildInputs = [
    qtbase
    cpp-utilities
    qtutilities
    boost
    qtforkawesome
  ] ++ lib.optionals stdenv.isDarwin [ iconv ]
    ++ lib.optionals webviewSupport [ qtwebengine ]
    ++ lib.optionals jsSupport [ qtdeclarative ]
    ++ lib.optionals kioPluginSupport [ kio ]
    ++ lib.optionals plasmoidSupport [ plasma-framework ]
  ;

  nativeBuildInputs = [
    wrapQtAppsHook
    cmake
    qttools
  ]
    ++ lib.optionals plasmoidSupport [ extra-cmake-modules ]
  ;

  # No tests are available by upstream, but we test --help anyway
  # Don't test on Darwin because output is .app
  doInstallCheck = !stdenv.isDarwin;
  installCheckPhase = ''
    $out/bin/syncthingtray --help | grep ${finalAttrs.version}
  '';

  cmakeFlags = [
    "-DAUTOSTART_EXEC_PATH=${autostartExecPath}"
    # See https://github.com/Martchus/syncthingtray/issues/42
    "-DQT_PLUGIN_DIR:STRING=${placeholder "out"}/${qtbase.qtPluginPrefix}"
    "-DBUILD_SHARED_LIBS=ON"
  ] ++ lib.optionals (!plasmoidSupport) ["-DNO_PLASMOID=ON"]
    ++ lib.optionals (!kioPluginSupport) ["-DNO_FILE_ITEM_ACTION_PLUGIN=ON"]
    ++ lib.optionals systemdSupport ["-DSYSTEMD_SUPPORT=ON"]
    ++ lib.optionals (!webviewSupport) ["-DWEBVIEW_PROVIDER:STRING=none"]
  ;

  meta = with lib; {
    homepage = "https://github.com/Martchus/syncthingtray";
    description = "Tray application and Dolphin/Plasma integration for Syncthing";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ doronbehar ];
    platforms = platforms.linux ++ platforms.darwin;
  };
})
