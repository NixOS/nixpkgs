{
  lib,
  stdenv,

  fetchFromGitHub,

  buildEnv,
  linkFarm,

  cmake,
  ninja,
  pkg-config,

  boost,
  freexl,
  libarchive,
  qt6,
  R,
  readstat,
  rPackages,
}:

let
  version = "0.19.3";

  src = fetchFromGitHub {
    owner = "jasp-stats";
    repo = "jasp-desktop";
    tag = "v${version}";
    fetchSubmodules = true;
    hash = "sha256-p489Q3jMQ7UWOCdAGskRF9KSLoRSatUwGVfj0/g4aPo=";
  };

  moduleSet = import ./modules.nix {
    inherit fetchFromGitHub rPackages;
    jasp-src = src;
    jasp-version = version;
  };

  inherit (moduleSet) engine modules;

  # Merges ${R}/lib/R with all used R packages (even propagated ones)
  customREnv = buildEnv {
    name = "jasp-${version}-env";
    paths = [
      "${R}/lib/R"
      rPackages.RInside
      engine.jaspBase # Should already be propagated from modules, but include it again, just in case
    ] ++ lib.attrValues modules;
  };

  modulesDir = linkFarm "jasp-${version}-modules" (
    lib.mapAttrsToList (name: drv: {
      name = name;
      path = "${drv}/library";
    }) modules
  );
in
stdenv.mkDerivation {
  pname = "jasp-desktop";
  inherit version src;

  patches = [
    # - ensure boost is linked dynamically
    # - fix readstat's find logic
    # - disable some of the renv logic
    # - dont't check for dependencies required for building modules
    ./cmake.patch
  ];

  cmakeFlags = [
    (lib.cmakeFeature "GITHUB_PAT" "dummy")
    (lib.cmakeFeature "GITHUB_PAT_DEF" "dummy")
    (lib.cmakeBool "LINUX_LOCAL_BUILD" false)
    (lib.cmakeBool "INSTALL_R_MODULES" false)
    (lib.cmakeFeature "CUSTOM_R_PATH" "${customREnv}")
  ];

  nativeBuildInputs = [
    cmake
    ninja
    pkg-config
    qt6.wrapQtAppsHook
  ];

  buildInputs = [
    boost
    customREnv
    freexl
    libarchive
    readstat

    qt6.qtbase
    qt6.qtdeclarative
    qt6.qtwebengine
    qt6.qtsvg
    qt6.qt5compat
  ];

  # needed so that JASPEngine can find libRInside.so
  env.NIX_LDFLAGS = "-L${rPackages.RInside}/library/RInside/lib";

  postInstall = ''
    # Remove unused cache locations
    rm -r $out/lib64 $out/Modules

    # Remove flatpak proxy script
    rm $out/bin/org.jaspstats.JASP
    substituteInPlace $out/share/applications/org.jaspstats.JASP.desktop \
      --replace-fail "Exec=org.jaspstats.JASP" "Exec=JASP"

    # symlink modules from the store
    ln -s ${modulesDir} $out/Modules
  '';

  passthru = {
    inherit modules engine;
    env = customREnv;
  };

  meta = {
    changelog = "https://jasp-stats.org/release-notes";
    description = "Complete statistical package for both Bayesian and Frequentist statistical methods";
    homepage = "https://github.com/jasp-stats/jasp-desktop";
    license = lib.licenses.agpl3Plus;
    mainProgram = "JASP";
    maintainers = with lib.maintainers; [ tomasajt ];
    # JASP's cmake build steps are really different on Darwin
    # Perhaps the Darwin-specific things could be changed to be the same as Linux
    platforms = lib.platforms.linux;
  };
}
