{
  stdenv,
  lib,
  fetchFromGitHub,
  cmake,
  qt6,
  sqlite,

  letos-plugins,
  includeOfficialPlugins ? lib.meta.availableOn stdenv.hostPlatform letos-plugins,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "letos";
  version = "4.0.4";

  src = fetchFromGitHub {
    owner = "pawelsalawa";
    repo = "letos";
    tag = finalAttrs.version;
    hash = "sha256-xcPnUE1T6SVogrRJ75/j+LkTrcM8Vy9rurw6q6jtyU0=";
  };

  nativeBuildInputs = [
    cmake
    qt6.qttools
    qt6.wrapQtAppsHook
  ];

  buildInputs = [
    qt6.qtbase
    qt6.qtdeclarative
    qt6.qtsvg
    qt6.qttools
    qt6.qtwayland
    sqlite
  ];

  __structuredAttrs = true;
  strictDeps = true;

  cmakeDir = "../Letos";

  cmakeFlags = [
    (lib.cmakeBool "BUILD_TESTING" false)
    # Enable Unix favored layout (i.e. FHS) and install it system-wide. Select
    # this only if you are a system administrator or distro packager.
    (lib.cmakeBool "WITH_UNIX_FAV" true)
  ]
  ++ lib.optionals includeOfficialPlugins [
    (lib.cmakeFeature "SYS_PLUGINS_DIR" "${letos-plugins}/lib/letos")
  ];

  postInstall = ''
    for size in 16 48 256; do
      mv \
        "$out/share/icons/hicolor/''${size}x''${size}/apps/letos_''${size}.png" \
        "$out/share/icons/hicolor/''${size}x''${size}/apps/letos.png"
    done

    install -Dm644 ../LICENSE -t "$out/share/licenses/letos"
    install -Dm644 ../README.md ../ChangeLog.md -t "$out/share/doc/letos"
  '';

  meta = {
    description = "Database manager for SQLite (formerly SQLiteStudio)";
    homepage = "https://letos.org";
    license = lib.licenses.gpl3Only;
    mainProgram = "letos";
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ asterismono ];
  };
})
