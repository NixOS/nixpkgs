{
  stdenv,
  lib,
  fetchFromGitHub,
  unstableGitUpdater,
  cmake,
  kdePackages,
  qt6Packages,
  mkcal,
  pkg-config,
  tzdata,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "qtorganizer-mkcal";
  version = "0-unstable-2026-06-06";

  src = fetchFromGitHub {
    owner = "dcaliste";
    repo = "qtorganizer-mkcal";
    rev = "6efa089553ccc3c44ada8fd2fe1349a004d4f619";
    hash = "sha256-vycfq5meq+u7Ntv0n1XrcqlZfjU7flfQAi17vZId6Ww=";
  };

  postPatch =
    # Use Qt6 things
    ''
      substituteInPlace CMakeLists.txt \
        --replace-fail 'QT_MIN_VERSION "5.6.0"' 'QT_MIN_VERSION "6.0.0"' \
        --replace-fail 'libmkcal-qt5' 'libmkcal-qt6'

      substituteInPlace CMakeLists.txt src/CMakeLists.txt tests/CMakeLists.txt \
        --replace-fail 'Qt5' 'Qt6' \
        --replace-fail 'KF5' 'KF6'
    ''
    # Adapt to Qt6 changes
    + ''
      substituteInPlace src/mkcalworker.h \
        --replace-fail \
          'QList<QtOrganizer::QOrganizerCollection> collections(QtOrganizer::QOrganizerManager::Error *error) const override' \
          'QList<QtOrganizer::QOrganizerCollection> collections(QtOrganizer::QOrganizerManager::Error *error) override'
    ''
    + ''
      substituteInPlace src/CMakeLists.txt \
        --replace-fail 'DESTINATION ''${CMAKE_INSTALL_LIBDIR}/qt5/plugins' 'DESTINATION ''${CMAKE_INSTALL_PREFIX}/${qt6Packages.qtbase.qtPluginPrefix}'
    '';

  strictDeps = true;

  nativeBuildInputs = [
    cmake
    kdePackages.extra-cmake-modules
    pkg-config
  ];

  buildInputs = [
    mkcal
  ]
  ++ (with kdePackages; [
    extra-cmake-modules
    kcalendarcore
  ])
  ++ (with qt6Packages; [
    qtbase
    qtpim
  ]);

  nativeCheckInputs = [
    tzdata
  ];

  dontWrapQtApps = true;

  # Flaky: https://github.com/dcaliste/qtorganizer-mkcal/issues/9
  doCheck = false;

  preCheck =
    let
      listToQtVar = suffix: lib.makeSearchPathOutput "bin" suffix;
    in
    ''
      export QT_QPA_PLATFORM=minimal
      export QT_PLUGIN_PATH=${
        listToQtVar qt6Packages.qtbase.qtPluginPrefix (
          with qt6Packages;
          [
            qtbase
            qtpim
          ]
        )
      }

      # Wants to load the just-built plugin, doesn't try to set up the build dir / environment for that
      mkdir -p $TMP/fake-install/organizer
      cp ./src/libqtorganizer_mkcal.so $TMP/fake-install/organizer
      export QT_PLUGIN_PATH=$TMP/fake-install:$QT_PLUGIN_PATH
    '';

  passthru.updateScript = unstableGitUpdater { };

  meta = {
    description = "QtOrganizer plugin using sqlite via mKCal";
    homepage = "https://github.com/dcaliste/qtorganizer-mkcal";
    license = lib.licenses.bsd3;
    teams = [ lib.teams.lomiri ];
    platforms = lib.platforms.linux;
  };
})
