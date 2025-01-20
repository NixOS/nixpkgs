{
  stdenv,
  lib,
  fetchFromGitHub,
  unstableGitUpdater,
  cmake,
  extra-cmake-modules,
  libsForQt5,
  mkcal,
  pkg-config,
  tzdata,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "qtorganizer-mkcal";
  version = "0-unstable-2024-10-01";

  src = fetchFromGitHub {
    owner = "dcaliste";
    repo = "qtorganizer-mkcal";
    rev = "1676e8b7e96911eb8899a864ffc0e77c04e2b25a";
    hash = "sha256-qrTP2SMy5fZFcpTufrJxEKTAl4nixVn5VOwt/Je3yXM=";
  };

  postPatch =
    ''
      substituteInPlace CMakeLists.txt \
        --replace-fail 'include(GNUInstallDirs)' 'include(GNUInstallDirs)
      include(CTest)'

      substituteInPlace src/CMakeLists.txt \
        --replace-fail 'DESTINATION ''${CMAKE_INSTALL_LIBDIR}/qt5/plugins' 'DESTINATION ''${CMAKE_INSTALL_PREFIX}/${libsForQt5.qtbase.qtPluginPrefix}'

      # Don't install the test binary
      substituteInPlace tests/CMakeLists.txt \
        --replace-fail 'install(TARGETS tst_engine' '# install(TARGETS tst_engine'
    ''
    + lib.optionalString (!finalAttrs.finalPackage.doCheck) ''
      substituteInPlace CMakeLists.txt \
        --replace-fail 'add_subdirectory(tests)' '# add_subdirectory(tests)'
    '';

  strictDeps = true;

  nativeBuildInputs = [
    cmake
    pkg-config
  ];

  buildInputs =
    [
      extra-cmake-modules
      mkcal
    ]
    ++ (with libsForQt5; [
      kcalendarcore
      qtbase
      qtpim
    ]);

  nativeCheckInputs = [
    tzdata
  ];

  dontWrapQtApps = true;

  doCheck = stdenv.buildPlatform.canExecute stdenv.hostPlatform;

  preCheck =
    let
      listToQtVar = suffix: lib.makeSearchPathOutput "bin" suffix;
    in
    ''
      export QT_QPA_PLATFORM=minimal
      export QT_PLUGIN_PATH=${
        listToQtVar libsForQt5.qtbase.qtPluginPrefix (
          with libsForQt5;
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
    maintainers = lib.teams.lomiri.members;
    platforms = lib.platforms.linux;
  };
})
