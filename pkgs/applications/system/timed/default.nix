{
  stdenv,
  lib,
  fetchFromGitHub,
  gitUpdater,
  testers,
  libiodata,
  pkg-config,
  qmake,
  qtbase,
  sailfish-access-control,
  tzdata,
  wrapQtAppsHook,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "timed";
  version = "3.6.24";

  outputs = [
    "out"
    "lib"
    "dev"
  ];

  src = fetchFromGitHub {
    owner = "sailfishos";
    repo = "timed";
    tag = finalAttrs.version;
    hash = "sha256-6axLd3XRCIsuYnKQ0AiCD6Cxut9Ck9hNWwIbkj4Aza8=";
  };

  postPatch = ''
    substituteInPlace src/{lib/lib,voland/voland}.pro \
      --replace-fail '$$[QT_INSTALL_LIBS]' "$lib/lib" \
      --replace-fail '/usr/include' "$dev/include" \
      --replace-fail '$$[QT_INSTALL_DATA]' "$dev"

    substituteInPlace src/server/server.pro \
      --replace-fail '/usr/bin' "$out/bin" \
      --replace-fail '/etc' "$out/etc" \
      --replace-fail '/usr/lib' "$out/lib"

    substituteInPlace tests/tests.pro \
      --replace-fail '/opt' "$dev/opt" \

    substituteInPlace tests/ut_networktime/ut_networktime.pro \
      --replace-fail '/opt' "$dev/opt" \
      --replace-fail '/etc' "$dev/etc"

    substituteInPlace tests/tst_events/tst_events.pro \
      --replace-fail '/opt' "$dev/opt"

    substituteInPlace tools/timedclient/timedclient.pro \
      --replace-fail '/usr/bin' "$out/bin"

    substituteInPlace \
      src/lib/aliases.cpp \
      src/server/settings.cpp \
      --replace-fail '/usr/share/zoneinfo' '${tzdata}/share/zoneinfo'
  '';

  # QMake doesn't handle this well
  strictDeps = false;

  nativeBuildInputs = [
    pkg-config
    qmake
    wrapQtAppsHook
  ];

  buildInputs = [
    libiodata
    sailfish-access-control
  ];

  # Do all configuring now, not during build
  postConfigure = ''
    make qmake_all
  '';

  env = {
    TIMED_VERSION = "${finalAttrs.version}";

    # Other subprojects expect library to already be present
    NIX_CFLAGS_COMPILE = "-isystem ${placeholder "dev"}/include";
    NIX_LDFLAGS = "-L${placeholder "out"}/lib";
  };

  preBuild = ''
    pushd src/lib
    make ''${enableParallelBuilding:+-j$NIX_BUILD_CORES}
    make install
    popd
  '';

  passthru = {
    updateScript = gitUpdater { };
    tests.pkg-config = testers.hasPkgConfigModules {
      package = finalAttrs.finalPackage;
      # Version fields exclude patch-level
    };
  };

  meta = {
    description = "Time daemon managing system time, time zone and settings";
    homepage = "https://github.com/sailfishos/timed";
    changelog = "https://github.com/sailfishos/timed/releases/tag/${finalAttrs.version}";
    license = lib.licenses.lgpl21Only;
    mainProgram = "timed";
    teams = [ lib.teams.lomiri ];
    platforms = lib.platforms.linux;
    pkgConfigModules = [
      "timed-qt${lib.versions.major qtbase.version}"
      "timed-voland-qt${lib.versions.major qtbase.version}"
    ];
  };
})
