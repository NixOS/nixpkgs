{ mkDerivation
, stdenv
, lib
, fetchFromGitHub
, qtbase
, qtwebengine
, qtdeclarative
, extra-cmake-modules
, cpp-utilities
, qtutilities
, cmake
, kio
, plasma-framework
, qttools
, webviewSupport ? true
, jsSupport ? true
, kioPluginSupport ? true
, plasmoidSupport  ? true
, systemdSupport ? true
}:

mkDerivation rec {
  version = "1.0.1";
  pname = "syncthingtray";

  src = fetchFromGitHub {
    owner = "Martchus";
    repo = "syncthingtray";
    rev = "v${version}";
    sha256 = "1dln5gh3p8nz9qmg07cw2s0lpzp3rfhyrwdhczj89g27bwk0lr4k";
  };

  buildInputs = [ qtbase cpp-utilities qtutilities ]
    ++ lib.optionals webviewSupport [ qtwebengine ]
    ++ lib.optionals jsSupport [ qtdeclarative ]
    ++ lib.optionals kioPluginSupport [ kio ]
    ++ lib.optionals plasmoidSupport [ extra-cmake-modules plasma-framework ]
  ;

  nativeBuildInputs = [ cmake qttools ];

  # No tests are available by upstream, but we test --help anyway
  doInstallCheck = true;
  installCheckPhase = ''
    $out/bin/syncthingtray --help | grep ${version}
  '';

  cmakeFlags = [
    # See https://github.com/Martchus/syncthingtray/issues/42
    "-DQT_PLUGIN_DIR:STRING=${placeholder "out"}/lib/qt-5"
  ] ++ lib.optionals (!plasmoidSupport) ["-DNO_PLASMOID=ON"]
    ++ lib.optionals (!kioPluginSupport) ["-DNO_FILE_ITEM_ACTION_PLUGIN=ON"]
    ++ lib.optionals systemdSupport ["-DSYSTEMD_SUPPORT=ON"]
    ++ lib.optionals (!webviewSupport) ["-DWEBVIEW_PROVIDER:STRING=none"]
  ;

  meta = with lib; {
    homepage = "https://github.com/Martchus/syncthingtray";
    description = "Tray application and Dolphin/Plasma integration for Syncthing";
    license = licenses.gpl2;
    maintainers = with maintainers; [ doronbehar ];
    platforms = platforms.linux;
  };
}
