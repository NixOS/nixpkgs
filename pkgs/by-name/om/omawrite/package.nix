{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  ctestCheckHook,
  dbus,
  fontconfig,
  makeFontsConf,
  noto-fonts,
  noto-fonts-cjk-sans,
  qt6,
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "omawrite";
  version = "0.7.8";

  strictDeps = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "omacom";
    repo = "omawrite";
    tag = "v${finalAttrs.version}";
    hash = "sha256-wsNNpCPneuAdu9rvxvM0PYnSBZGA3rMLjehbXarXBSs=";
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

  # dbus-daemon --session looks for /etc/dbus-1/session.conf, which does not exist in the Nix sandbox.
  postPatch = ''
    substituteInPlace tests/omawrite_tests.cpp \
      --replace-fail 'QStringLiteral("--session")' 'QStringLiteral("--config-file=${dbus}/share/dbus-1/session.conf")'
  '';

  doCheck = stdenv.buildPlatform.canExecute stdenv.hostPlatform;

  preCheck = ''
    export HOME=$(mktemp -d)
    export QT_PLUGIN_PATH="${qt6.qtbase}/${qt6.qtbase.qtPluginPrefix}:${qt6.qtdeclarative}/${qt6.qtbase.qtPluginPrefix}"
    export QML2_IMPORT_PATH="${qt6.qtdeclarative}/${qt6.qtbase.qtQmlPrefix}"
    export FONTCONFIG_FILE=${
      makeFontsConf {
        fontDirectories = [
          noto-fonts
          noto-fonts-cjk-sans
        ];
        includes = [ "${fontconfig.out}/etc/fonts/conf.d" ];
      }
    }
    DBUS_SESSION_BUS_ADDRESS="$(dbus-daemon --config-file=${dbus}/share/dbus-1/session.conf --fork --print-address)"
    export DBUS_SESSION_BUS_ADDRESS
  '';

  installPhase = ''
    runHook preInstall
    install -Dm755 omawrite "$out/bin/omawrite"
    install -Dm644 ../pkgbuild/omawrite.svg "$out/share/icons/hicolor/scalable/apps/omawrite.svg"
    install -Dm644 ../pkgbuild/omawrite.desktop "$out/share/applications/omawrite.desktop"
    runHook postInstall
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Distraction-free Markdown writing app built with Qt Quick";
    homepage = "https://github.com/omacom/omawrite";
    changelog = "https://github.com/omacom/omawrite/releases/tag/${finalAttrs.src.tag}";
    license = with lib.licenses; [
      mit
      ofl
    ];
    maintainers = with lib.maintainers; [ kleinbem ];
    platforms = lib.platforms.linux;
    mainProgram = "omawrite";
  };
})
