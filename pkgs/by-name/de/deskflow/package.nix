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
}:

stdenv.mkDerivation {
  pname = "deskflow";
  version = "1.17.0.103";

  src = fetchFromGitHub {
    owner = "deskflow";
    repo = "deskflow";
    rev = "1b904e7c02ee2d514ef2d4a9a9312850bd058f1a";
    hash = "sha256-x7wpa3wvbIE0BS/k/y5bZzuH3DFufS7wCcJcmEOX5PQ=";
  };

  nativeBuildInputs = [
    cmake
    ninja
    pkg-config
    qt6.wrapQtAppsHook
  ];

  cmakeFlags = [
    "-DCMAKE_SKIP_RPATH=ON"
  ];

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
  ];

  postInstall = ''
    substituteInPlace $out/share/applications/deskflow.desktop \
        --replace-fail "Path=/usr/bin" "Path=$out/bin" \
        --replace-fail "Exec=/usr/bin/deskflow" "Exec=deskflow"
  '';

  meta = {
    homepage = "https://github.com/deskflow/deskflow";
    description = "Share one mouse and keyboard between multiple computers on Windows, macOS and Linux";
    mainProgram = "deskflow";
    maintainers = with lib.maintainers; [ aucub ];
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.linux;
  };
}
