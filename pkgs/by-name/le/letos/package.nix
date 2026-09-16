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
  version = "4.0.3";

  src = fetchFromGitHub {
    owner = "pawelsalawa";
    repo = "letos";
    tag = finalAttrs.version;
    hash = "sha256-//04MG1uLxNzbU3MEccVLp7L1pfZGC0pj3/Dw3+/SSE=";
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
    qt6.qtwayland
    sqlite
  ];

  __structuredAttrs = true;
  strictDeps = true;

  postPatch = ''
    substituteInPlace Letos/letos/main.cpp \
      --replace-fail \
        'qunsetenv("QT_PLUGIN_PATH");' \
        'qputenv("QT_PLUGIN_PATH", qgetenv("NIXPKGS_LETOS_QT_PLUGIN_PATH"));'
  '';

  cmakeDir = "../Letos";

  cmakeFlags = [
    (lib.cmakeBool "BUILD_TESTING" false)
  ]
  ++ lib.optionals includeOfficialPlugins [
    (lib.cmakeFeature "SYS_PLUGINS_DIR" "${letos-plugins}/lib/letos")
  ];

  qtWrapperArgs = [
    "--set"
    "NIXPKGS_LETOS_QT_PLUGIN_PATH"
    (lib.makeSearchPath "lib/qt-6/plugins" [
      qt6.qtbase
      qt6.qtsvg
      qt6.qtwayland
    ])
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
