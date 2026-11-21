{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  ctestCheckHook,
  dbus,
  qt6,
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "omacalc";
  version = "0.4.2";

  strictDeps = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "omacom";
    repo = "omacalc";
    tag = "v${finalAttrs.version}";
    hash = "sha256-7VnysQdDX9I/a1hQZjcZlvLy9ioxeC4UDls/FSYIQtw=";
  };

  nativeBuildInputs = [
    cmake
    qt6.wrapQtAppsHook
  ];

  buildInputs = [
    qt6.qtbase
    qt6.qtdeclarative
    qt6.qtwayland
  ];

  nativeCheckInputs = [
    ctestCheckHook
    dbus
  ];

  doCheck = stdenv.buildPlatform.canExecute stdenv.hostPlatform;

  preCheck = ''
    export HOME=$(mktemp -d)
    export QT_PLUGIN_PATH="${qt6.qtbase}/${qt6.qtbase.qtPluginPrefix}:${qt6.qtdeclarative}/${qt6.qtbase.qtPluginPrefix}"
    export QML2_IMPORT_PATH="${qt6.qtdeclarative}/${qt6.qtbase.qtQmlPrefix}"
    DBUS_SESSION_BUS_ADDRESS="$(dbus-daemon --config-file=${dbus}/share/dbus-1/session.conf --fork --print-address)"
    export DBUS_SESSION_BUS_ADDRESS
  '';

  installPhase = ''
    runHook preInstall
    install -Dm755 omacalc "$out/bin/omacalc"
    install -Dm644 ../pkgbuild/omacalc.svg "$out/share/icons/hicolor/scalable/apps/omacalc.svg"
    install -Dm644 ../pkgbuild/omacalc.desktop "$out/share/applications/omacalc.desktop"
    runHook postInstall
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Simple calculator written in Qt Quick";
    homepage = "https://github.com/omacom/omacalc";
    license = with lib.licenses; [
      mit
      ofl
    ];
    maintainers = with lib.maintainers; [ kleinbem ];
    platforms = lib.platforms.linux;
    mainProgram = "omacalc";
  };
})
