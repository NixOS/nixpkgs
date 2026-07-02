{
  stdenv,
  lib,
  fetchFromGitHub,
  unstableGitUpdater,
  cmake,
  kdePackages,
  libsForQt5,
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

  postPatch = ''
    substituteInPlace src/CMakeLists.txt \
      --replace-fail 'DESTINATION ''${CMAKE_INSTALL_LIBDIR}/qt5/plugins' 'DESTINATION ''${CMAKE_INSTALL_PREFIX}/${libsForQt5.qtbase.qtPluginPrefix}'
  '';

  strictDeps = true;

  nativeBuildInputs = [
    cmake
    kdePackages.extra-cmake-modules
    pkg-config
  ];

  buildInputs = [
    kdePackages.extra-cmake-modules
    mkcal
  ]
  ++ (with libsForQt5; [
    __internalKF5.kcalendarcore
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
    teams = [ lib.teams.lomiri ];
    platforms = lib.platforms.linux;
  };
})
