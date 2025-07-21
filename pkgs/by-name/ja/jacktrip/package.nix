{
  lib,
  stdenv,
  fetchFromGitHub,
  pkg-config,
  help2man,
  libjack2,
  libsamplerate,
  dbus,
  qt6,
  meson,
  python3,
  rtaudio,
  ninja,
  versionCheckHook,
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  version = "2.7.1";
  pname = "jacktrip";

  src = fetchFromGitHub {
    owner = "jacktrip";
    repo = "jacktrip";
    tag = "v${finalAttrs.version}";
    fetchSubmodules = true;
    hash = "sha256-47CgvaNgAr3PP61vS28hU4jTljukFGbGkAYJVHNoR9U=";
  };

  preConfigure = ''
    rm build
  '';

  buildInputs = [
    rtaudio
    qt6.qtbase
    qt6.qtwayland
    libjack2
    libsamplerate
    dbus
  ];

  nativeBuildInputs = [
    python3
    python3.pkgs.pyaml
    python3.pkgs.jinja2
    ninja
    help2man
    meson
    qt6.qt5compat
    qt6.qtnetworkauth
    qt6.qtwebsockets
    qt6.qtwebengine
    qt6.qtdeclarative
    qt6.qtsvg
    qt6.wrapQtAppsHook
    pkg-config
  ];

  qmakeFlags = [ "jacktrip.pro" ];

  nativeInstallCheckInputs = [
    versionCheckHook
  ];
  versionCheckProgramArg = "--version";
  doInstallCheck = true;

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Multi-machine audio network performance over the Internet";
    homepage = "https://jacktrip.github.io/jacktrip/";
    changelog = "https://github.com/jacktrip/jacktrip/releases/tag/v${finalAttrs.version}";
    license = with lib.licenses; [
      gpl3
      lgpl3
      mit
    ];
    maintainers = with lib.maintainers; [ iwanb ];
    platforms = lib.platforms.linux;
    mainProgram = "jacktrip";
  };
})
