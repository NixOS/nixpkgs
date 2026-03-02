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
  librdata,
  qt6,
  R,
  readstat,
  rPackages,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "jasp-desktop";
  version = "0.95.4";
  src = fetchFromGitHub {
    owner = "jasp-stats";
    repo = "jasp-desktop";
    tag = "v${finalAttrs.version}";
    fetchSubmodules = true;
    hash = "sha256-n7lXedICK+sAuSW6hODy+TngAZpDIObWDhTtOjiTXgc=";
  };

  patches = [
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
    (lib.cmakeFeature "CUSTOM_R_PATH" "${finalAttrs.passthru.customREnv}")
  ];

  nativeBuildInputs = [
    cmake
    ninja
    pkg-config
    qt6.wrapQtAppsHook
  ];

  buildInputs = [
    finalAttrs.passthru.customREnv
    boost
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
    ln -s ${finalAttrs.passthru.moduleLibs} $out/Modules/module_libs
  '';

  passthru = {
    inherit
      (import ./modules.nix {
        inherit fetchFromGitHub rPackages;
        jasp-src = finalAttrs.src;
        jasp-version = finalAttrs.version;
      })
      jaspBase
      modules
      ;

    # Merges ${R}/lib/R with all used R packages (even propagated ones)
    customREnv = buildEnv {
      name = "jasp-desktop-${finalAttrs.version}-env";
      paths = [
        "${R}/lib/R"
        rPackages.RInside
        finalAttrs.passthru.jaspBase # Should already be propagated from modules, but include it again, just in case
      ]
      ++ lib.attrValues finalAttrs.passthru.modules;
    };

    moduleLibs = linkFarm "jasp-desktop-${finalAttrs.version}-module-libs" (
      lib.mapAttrsToList (name: drv: {
        name = name;
        path = "${drv}/library";
      }) finalAttrs.passthru.modules
    );
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
})
