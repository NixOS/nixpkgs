{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  ctestCheckHook,
  dbus,
  qt6,
  ffmpeg,
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "omacut";
  version = "0.8.3";

  strictDeps = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "omacom";
    repo = "omacut";
    tag = "v${finalAttrs.version}";
    hash = "sha256-koyV60EFls7RW1/mUGhs8HMhj5wFKe3BSHssl0EP/uw=";
  };

  nativeBuildInputs = [
    cmake
    qt6.wrapQtAppsHook
  ];

  buildInputs = [
    qt6.qtbase
    qt6.qtdeclarative
    qt6.qtmultimedia
    qt6.qtwayland
  ];

  nativeCheckInputs = [
    ctestCheckHook
    dbus
    ffmpeg
  ];

  doCheck = stdenv.buildPlatform.canExecute stdenv.hostPlatform;

  preCheck = ''
    export HOME=$(mktemp -d)
    export QT_PLUGIN_PATH="${qt6.qtbase}/${qt6.qtbase.qtPluginPrefix}:${qt6.qtmultimedia}/${qt6.qtbase.qtPluginPrefix}:${qt6.qtdeclarative}/${qt6.qtbase.qtPluginPrefix}"
    export QML2_IMPORT_PATH="${qt6.qtdeclarative}/${qt6.qtbase.qtQmlPrefix}:${qt6.qtmultimedia}/${qt6.qtbase.qtQmlPrefix}"
    DBUS_SESSION_BUS_ADDRESS="$(dbus-daemon --config-file=${dbus}/share/dbus-1/session.conf --fork --print-address)"
    export DBUS_SESSION_BUS_ADDRESS
  '';

  installPhase = ''
    runHook preInstall
    install -Dm755 omacut "$out/bin/omacut"
    install -Dm644 ../pkgbuild/omacut.svg "$out/share/icons/hicolor/scalable/apps/omacut.svg"
    install -Dm644 ../pkgbuild/omacut.desktop "$out/share/applications/omacut.desktop"
    runHook postInstall
  '';

  qtWrapperArgs = [
    "--prefix"
    "PATH"
    ":"
    (lib.makeBinPath [ ffmpeg ])
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Simple video length trimmer written in Qt Quick";
    homepage = "https://github.com/omacom/omacut";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ kleinbem ];
    platforms = lib.platforms.linux;
    mainProgram = "omacut";
  };
})
