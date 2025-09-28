{
  lib,
  stdenv,

  fetchFromGitHub,
  fetchpatch,

  buildEnv,
  linkFarm,

  cmake,
  ninja,
  pkg-config,

  boost,
  freexl,
  libarchive,
  librdata,
  qt6,
  R,
  readstat,
  rPackages,
}:

let
  version = "0.95.0";

  src = fetchFromGitHub {
    owner = "jasp-stats";
    repo = "jasp-desktop";
    tag = "v${version}";
    fetchSubmodules = true;
    hash = "sha256-RR7rJJb0qKqZs7K3zP6GxlDXpmSNnGQ3WDExUgm9pKQ=";
  };

  moduleSet = import ./modules.nix {
    inherit fetchFromGitHub rPackages;
    jasp-src = src;
    jasp-version = version;
  };

  inherit (moduleSet) jaspBase modules;

  # Merges ${R}/lib/R with all used R packages (even propagated ones)
  customREnv = buildEnv {
    name = "jasp-${version}-env";
    paths = [
      "${R}/lib/R"
      rPackages.RInside
      jaspBase # Should already be propagated from modules, but include it again, just in case
    ]
    ++ lib.attrValues modules;
  };

  moduleLibs = linkFarm "jasp-${version}-module-libs" (
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
    (fetchpatch {
      name = "readstat-use-find-library.patch";
      url = "https://github.com/jasp-stats/jasp-desktop/commit/87c5a1f4724833aed0f7758499b917b3107ee196.patch";
      hash = "sha256-0CrMKJkZpS97KmQFvZPyV1h3C7eKVr/IT0dARYBoKFo=";
    })
    ./link-boost-dynamically.patch
    ./disable-module-install-logic.patch # don't try to install modules via cmake
    ./disable-renv-logic.patch
    ./dont-check-for-module-deps.patch # dont't check for dependencies required for building modules
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
    librdata
    readstat

    qt6.qtbase
    qt6.qtdeclarative
    qt6.qtwebengine
    qt6.qtsvg
    qt6.qt5compat
  ];

  # needed so that the linker can find libRInside.so
  env.NIX_LDFLAGS = "-L${rPackages.RInside}/library/RInside/lib";

  postInstall = ''
    # Remove flatpak proxy script
    rm $out/bin/org.jaspstats.JASP
    substituteInPlace $out/share/applications/org.jaspstats.JASP.desktop \
      --replace-fail "Exec=org.jaspstats.JASP" "Exec=JASP"

    # symlink modules from the store
    ln -s ${moduleLibs} $out/Modules/module_libs
  '';

  passthru = {
    inherit jaspBase modules;
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
