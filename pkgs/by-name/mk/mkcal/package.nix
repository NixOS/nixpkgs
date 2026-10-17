{
  stdenv,
  lib,
  fetchFromGitHub,
  makeFontsConf,
  unstableGitUpdater,
  testers,
  cmake,
  ctestCheckHook,
  doxygen,
  kdePackages,
  graphviz,
  qt6Packages,
  perl,
  pkg-config,
  tzdata,
  writableTmpDirAsHomeHook,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "mkcal";
  version = "0.7.33-unstable-2026-05-25";

  src = fetchFromGitHub {
    owner = "sailfishos";
    repo = "mkcal";
    rev = "f53e4ade3debb20e3273df0a6a0b3e4b492ddc29";
    hash = "sha256-U3lqsQO+b6yci4q6jze+W4tw/LA/g+hr03lzkniL5b4=";
  };

  outputs = [
    "out"
    "dev"
    "doc"
  ];

  postPatch = ''
    substituteInPlace doc/CMakeLists.txt \
      --replace-fail 'COMMAND ''${DOXYGEN}' 'WORKING_DIRECTORY ''${CMAKE_SOURCE_DIR} COMMAND ''${DOXYGEN}'

    # Dynamic menus are broken in docs
    sed -i doc/libmkcal.cfg -e '1i HTML_DYNAMIC_MENUS = NO'
  '';

  strictDeps = true;

  nativeBuildInputs = [
    cmake
    doxygen
    graphviz
    perl
    pkg-config
    writableTmpDirAsHomeHook
  ]
  #++ (with kdePackages; [
  #  kdePackages.extra-cmake-modules
  #])
  ++ (with qt6Packages; [
    wrapQtAppsHook
  ]);

  buildInputs = (with kdePackages; [
    extra-cmake-modules
    kcalendarcore
  ])
  ++ (with qt6Packages; [
    qtbase
    #qtpim
    timed
  ]);

  nativeCheckInputs = [
    tzdata
    ctestCheckHook
  ];

  cmakeFlags = [
    (lib.cmakeBool "BUILD_DOCUMENTATION" true)
    (lib.cmakeBool "BUILD_PLUGINS" false)
    (lib.cmakeBool "BUILD_TESTS" finalAttrs.finalPackage.doCheck)
    (lib.cmakeBool "ENABLE_QT6" true)
    (lib.cmakeBool "INSTALL_TESTS" false)
  ];

  env.FONTCONFIG_FILE = makeFontsConf { fontDirectories = [ ]; };

  doCheck = stdenv.buildPlatform.canExecute stdenv.hostPlatform;
  disabledTests = [
    # Test expects to be passed a real, already existing database to test migrations. We don't have one
    "tst_perf"

    # 10/97 tests fail. Half seem related to time (zone) issues w/ local time / Helsinki timezone
    # Other half are x-1/x on lists of alarms/events
    "tst_storage"
  ];

  # Parallelism breaks tests
  enableParallelChecking = false;

  preCheck = ''
    export HOME=$TMP
    export QT_QPA_PLATFORM=minimal
    export QT_PLUGIN_PATH=${lib.getBin qt6Packages.qtbase}/${qt6Packages.qtbase.qtPluginPrefix}
  '';

  passthru = {
    updateScript = unstableGitUpdater { };
    tests.pkg-config = testers.hasPkgConfigModules {
      package = finalAttrs.finalPackage;
      # version field doesn't exactly match current version
    };
  };

  meta = {
    description = "Mobile version of the original KCAL from KDE";
    homepage = "https://github.com/sailfishos/mkcal";
    changelog = "https://github.com/sailfishos/mkcal/releases/tag/${finalAttrs.version}";
    license = lib.licenses.lgpl2Plus;
    mainProgram = "mkcaltool";
    teams = [ lib.teams.lomiri ];
    platforms = lib.platforms.linux;
    pkgConfigModules = [
      "libmkcal-qt6"
    ];
  };
})
