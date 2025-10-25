{
  stdenv,
  lib,
  fetchFromGitHub,
  gitUpdater,
  testers,
  cmake,
  doxygen,
  extra-cmake-modules,
  graphviz,
  libsForQt5,
  perl,
  pkg-config,
  tzdata,
  ctestCheckHook,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "mkcal";
  version = "0.7.29";

  src = fetchFromGitHub {
    owner = "sailfishos";
    repo = "mkcal";
    tag = finalAttrs.version;
    hash = "sha256-H7TWu6tTh1vBmFx7kRpyijLCg0xs+dYIEJAERBEGh8g=";
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
    extra-cmake-modules
    doxygen
    graphviz
    perl
    pkg-config
  ]
  ++ (with libsForQt5; [
    wrapQtAppsHook
  ]);

  buildInputs = with libsForQt5; [
    kcalendarcore
    qtbase
    qtpim
    timed
  ];

  nativeCheckInputs = [
    tzdata
    ctestCheckHook
  ];

  cmakeFlags = [
    (lib.cmakeBool "BUILD_PLUGINS" false)
    (lib.cmakeBool "BUILD_TESTS" finalAttrs.finalPackage.doCheck)
    (lib.cmakeBool "INSTALL_TESTS" false)
    (lib.cmakeBool "BUILD_DOCUMENTATION" true)
  ];

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
    export QT_PLUGIN_PATH=${lib.getBin libsForQt5.qtbase}/${libsForQt5.qtbase.qtPluginPrefix}
  '';

  passthru = {
    updateScript = gitUpdater { };
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
      "libmkcal-qt5"
    ];
  };
})
