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
  wayland-protocols,
  wayland,
  libsysprof-capture,
  lerc,
  doxygen,
  writableTmpDirAsHomeHook,
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "deskflow";
  version = "1.24.0";

  src = fetchFromGitHub {
    owner = "deskflow";
    repo = "deskflow";
    tag = "v${finalAttrs.version}";
    hash = "sha256-eXQXHi8TMMwyIkZ7gQ9GHIzSOM2rtzV+w1R7hxS+WSA=";
  };

  postPatch = ''
    substituteInPlace src/lib/deskflow/unix/AppUtilUnix.cpp \
      --replace-fail "/usr/share/X11/xkb/rules/evdev.xml" "${xkeyboard_config}/share/X11/xkb/rules/evdev.xml"
    substituteInPlace deploy/linux/deploy.cmake \
      --replace-fail 'message(FATAL_ERROR "Unable to read file /etc/os-release")' 'set(RELEASE_FILE_CONTENTS "")'
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

  nativeCheckInputs = [ writableTmpDirAsHomeHook ];

  checkPhase = ''
    runHook preCheck

    export QT_QPA_PLATFORM=offscreen
    ./bin/legacytests

    runHook postCheck
  '';

  postInstall = ''
    install -Dm644 ../README.md ../doc/user/configuration.md -t $out/share/doc/deskflow
  '';

  passthru.updateScript = nix-update-script {
    extraArgs = [
      "--version-regex"
      "^v([0-9.]+)$"
    ];
  };

  meta = {
    homepage = "https://github.com/deskflow/deskflow";
    description = "Share one mouse and keyboard between multiple computers on Windows, macOS and Linux";
    mainProgram = "deskflow";
    maintainers = with lib.maintainers; [ flacks ];
    license = with lib; [
      licenses.gpl2Plus
      licenses.openssl
      licenses.mit # share/applications/org.deskflow.deskflow.desktop
    ];
    platforms = lib.platforms.linux;
  };
})
