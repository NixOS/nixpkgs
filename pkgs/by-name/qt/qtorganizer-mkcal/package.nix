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
  version = "0-unstable-2025-04-24";

  src = fetchFromGitHub {
    owner = "dcaliste";
    repo = "qtorganizer-mkcal";
    rev = "45906b1df8ad758a824369873f423d9e0c457fbf";
    hash = "sha256-sgYCO8LxBFhMkjGnKVvOx2d4hyw9Oa5lbu6LKhuwl8s=";
  };

  postPatch = ''
    substituteInPlace src/CMakeLists.txt \
      --replace-fail 'DESTINATION ''${CMAKE_INSTALL_LIBDIR}/qt5/plugins' 'DESTINATION ''${CMAKE_INSTALL_PREFIX}/${libsForQt5.qtbase.qtPluginPrefix}'
  '';

  strictDeps = true;

  nativeBuildInputs = [
    cmake
    extra-cmake-modules
    pkg-config
  ];

  buildInputs = [
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
