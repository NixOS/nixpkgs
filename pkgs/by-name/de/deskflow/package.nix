{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  ninja,
  pkg-config,
  tomlplusplus,
  cli11,
  gtest,
  libei,
  libportal,
  libX11,
  libxkbfile,
  libXtst,
  libXinerama,
  libXi,
  libXrandr,
  libxkbcommon,
  pugixml,
  python3,
  gdk-pixbuf,
  libnotify,
  qt6,
  xkeyboard_config,
  openssl,
  wayland-protocols,
  wayland,
  libsysprof-capture,
  lerc,
  doxygen,
}:
stdenv.mkDerivation rec {
  pname = "deskflow";
  version = "1.17.2";

  src = fetchFromGitHub {
    owner = "deskflow";
    repo = "deskflow";
    rev = "refs/tags/v${version}";
    hash = "sha256-CHlvL/MC9clFrMxlfIXaCFoTkcLS7QsYK7MXMFW0188=";
  };

  postPatch = ''
    substituteInPlace src/lib/deskflow/unix/AppUtilUnix.cpp \
      --replace-fail "/usr/share/X11/xkb/rules/evdev.xml" "${xkeyboard_config}/share/X11/xkb/rules/evdev.xml"
    substituteInPlace src/lib/gui/tls/TlsCertificate.cpp \
      --replace-fail "\"openssl\"" "\"${lib.getBin openssl}/bin/openssl\""
  '';

  nativeBuildInputs = [
    cmake
    ninja
    pkg-config
    qt6.wrapQtAppsHook
    doxygen # docs
  ];

  cmakeFlags = [
    "-DCMAKE_SKIP_RPATH=ON" # Avoid generating incorrect RPATH
  ];

  strictDeps = true;

  buildInputs = [
    tomlplusplus
    cli11
    gtest
    libei
    libportal
    libX11
    libxkbfile
    libXinerama
    libXi
    libXrandr
    libXtst
    libxkbcommon
    pugixml
    gdk-pixbuf
    libnotify
    python3
    qt6.qtbase
    wayland-protocols
    qt6.qtwayland
    wayland
    libsysprof-capture
    lerc
  ];

  qtWrapperArgs = [
    "--set QT_QPA_PLATFORM_PLUGIN_PATH ${qt6.qtwayland}/${qt6.qtbase.qtPluginPrefix}/platforms"
  ];

  doCheck = true;

  checkPhase = ''
    runHook preCheck

    export QT_QPA_PLATFORM=offscreen
    export HOME=$(mktemp -d)
    ./bin/unittests
    ./bin/integtests

    runHook postCheck
  '';

  meta = {
    homepage = "https://github.com/deskflow/deskflow";
    description = "Share one mouse and keyboard between multiple computers on Windows, macOS and Linux";
    mainProgram = "deskflow";
    maintainers = with lib.maintainers; [ aucub ];
    license = with lib; [
      licenses.gpl2Plus
      licenses.openssl
    ];
    platforms = lib.platforms.linux;
  };
}
