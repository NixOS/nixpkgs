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

stdenv.mkDerivation rec {
  pname = "deskflow";

  version = "1.17.0";

  src = fetchFromGitHub {
    owner = "deskflow";
    repo = "deskflow";
    rev = "${version}+r1";
    hash = "sha256-OXgL3AmN5s38tlp3yYcMc6y9y8Gf48FuaD0ilKnoKiE=";
  };

  nativeBuildInputs = [
    cmake
    ninja
    pkg-config
    qt6.wrapQtAppsHook
  ];

  postPatch = ''
    substituteInPlace cmake/Packaging.cmake --replace-warn "set(CMAKE_INSTALL_PREFIX /usr)" ""
  '';

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
    description = "Deskflow lets you share one mouse and keyboard between multiple computers on Windows, macOS and Linux";
    mainProgram = "deskflow";
    maintainers = with lib.maintainers; [ aucub ];
    license = lib.licenses.gpl2Plus;
    platforms = [
      "x86_64-linux"
      "aarch64-darwin"
    ];
    broken = stdenv.hostPlatform.isDarwin;
  };
}
