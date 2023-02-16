{ mkDerivation
, lib
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
  version = "1.3.1";
  pname = "syncthingtray";

  src = fetchFromGitHub {
    owner = "Martchus";
    repo = "syncthingtray";
    rev = "v${version}";
    sha256 = "sha256-0rmfDkPvgubVqfbIOZ+mnv/x1p2sb88zGeg/Q2JCy3I=";
  };

  patches = [
    # Fix Exec= path in runtime-generated
    # ~/.config/autostart/syncthingtray.desktop file - this is required because
    # we are wrapping the executable. We can't use `substituteAll` because we
    # can't use `${placeholder "out"}` because that will produce the $out of
    # the patch derivation itself, and not of syncthing's "out" placeholder.
    # Hence we use a C definition with NIX_CFLAGS_COMPILE
    ./use-nix-path-in-autostart.patch
  ];
  NIX_CFLAGS_COMPILE = "-DEXEC_NIX_PATH=\"${placeholder "out"}/bin/syncthingtray\"";

  buildInputs = [
    qtbase
    cpp-utilities
    qtutilities
    boost
    qtforkawesome
  ]
    ++ lib.optionals webviewSupport [ qtwebengine ]
    ++ lib.optionals jsSupport [ qtdeclarative ]
    ++ lib.optionals kioPluginSupport [ kio ]
    ++ lib.optionals plasmoidSupport [ plasma-framework ]
  ;

  nativeBuildInputs = [
    cmake
    qttools
  ]
    ++ lib.optionals plasmoidSupport [ extra-cmake-modules ]
  ;

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
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ doronbehar ];
    platforms = platforms.linux;
  };
}
