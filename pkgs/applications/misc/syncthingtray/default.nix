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
  version = "0.10.1";
  pname = "syncthingtray";

  src = fetchFromGitHub {
    owner = "Martchus";
    repo = "syncthingtray";
    rev = "v${version}";
    sha256 = "107w6dlr1m5g60j342p2b6ipfn1r8kyad8av58nh8ibzycghbfv2";
  };

  buildInputs = [ qtbase cpp-utilities qtutilities ]
    ++ lib.optionals webviewSupport [ qtwebengine ]
    ++ lib.optionals jsSupport [ qtdeclarative ]
    ++ lib.optionals kioPluginSupport [ kio ]
    ++ lib.optionals plasmoidSupport [ extra-cmake-modules plasma-framework ]
  ;

  nativeBuildInputs = [ cmake qttools ];

  cmakeFlags = [
    # See https://github.com/Martchus/syncthingtray/issues/42
    "-DQT_PLUGIN_DIR:STRING=${placeholder "out"}/lib/qt-5"
  ] ++ lib.optionals (!plasmoidSupport) ["-DNO_PLASMOID=ON"]
    ++ lib.optionals (!kioPluginSupport) ["-DNO_FILE_ITEM_ACTION_PLUGIN=ON"]
    ++ lib.optionals systemdSupport ["-DSYSTEMD_SUPPORT=ON"]
  ;

  meta = with lib; {
    homepage = "https://github.com/Martchus/syncthingtray";
    description = "Tray application and Dolphin/Plasma integration for Syncthing";
    license = licenses.gpl2;
    maintainers = with maintainers; [ doronbehar ];
    platforms = platforms.linux;
  };
}
