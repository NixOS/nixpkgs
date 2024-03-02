{ lib
, stdenv
, fetchFromGitHub
, callPackage
, buildEnv
, linkFarm
, substituteAll
, R
, rPackages
, cmake
, ninja
, pkg-config
, boost
, libarchive
, readstat
, qt6
}:

let
  version = "0.18.3";

  src = fetchFromGitHub {
    owner = "jasp-stats";
    repo = "jasp-desktop";
    rev = "v${version}";
    hash = "sha256-eKBxCIamNhUig+0vUEqXYbPjiaOsZk6QnOw8cnpjKFY=";
    fetchSubmodules = true;
  };

  inherit (callPackage ./modules.nix {
    jasp-src = src;
    jasp-version = version;
  }) engine modules;

  # Merges ${R}/lib/R with all used R packages (even propagated ones)
  customREnv = buildEnv {
    name = "jasp-${version}-env";
    paths = [
      "${R}/lib/R"
      rPackages.RInside
      engine.jaspBase # Should already be propagated from modules, but include it again, just in case
    ] ++ lib.attrValues modules;
  };

  modulesDir = linkFarm "jasp-${version}-modules"
    (lib.mapAttrsToList (name: drv: { name = name; path = "${drv}/library"; }) modules);
in
stdenv.mkDerivation {
  pname = "jasp-desktop";
  inherit version src;

  patches = [
    # remove unused cmake deps, ensure boost is dynamically linked, patch readstat path
    (substituteAll {
      src = ./cmake.patch;
      inherit readstat;
    })
  ];

  cmakeFlags = [
    "-DGITHUB_PAT=dummy"
    "-DGITHUB_PAT_DEF=dummy"
    "-DINSTALL_R_FRAMEWORK=OFF"
    "-DLINUX_LOCAL_BUILD=OFF"
    "-DINSTALL_R_MODULES=OFF"
    "-DCUSTOM_R_PATH=${customREnv}"
  ];

  nativeBuildInputs = [
    cmake
    ninja
    pkg-config
    qt6.wrapQtAppsHook
  ];

  buildInputs = [
    customREnv
    boost
    libarchive
    readstat
  ] ++ (with qt6; [
    qtbase
    qtdeclarative
    qtwebengine
    qtsvg
    qt5compat
  ]);

  env.NIX_LDFLAGS = "-L${rPackages.RInside}/library/RInside/lib";

  postInstall = ''
    # Remove unused cache locations
    rm -r $out/lib64 $out/Modules

    # Remove flatpak proxy script
    rm $out/bin/org.jaspstats.JASP
    substituteInPlace $out/share/applications/org.jaspstats.JASP.desktop \
        --replace "Exec=org.jaspstats.JASP" "Exec=JASP"

    # symlink modules from the store
    ln -s ${modulesDir} $out/Modules
  '';

  passthru = {
    inherit modules engine;
    env = customREnv;
  };

  meta = {
    changelog = "https://jasp-stats.org/release-notes";
    description = "A complete statistical package for both Bayesian and Frequentist statistical methods";
    homepage = "https://github.com/jasp-stats/jasp-desktop";
    license = lib.licenses.agpl3;
    mainProgram = "JASP";
    maintainers = with lib.maintainers; [ tomasajt ];
    # JASP's cmake build steps are really different on Darwin
    # Perhaps the Darwin-specific things could be changed to be the same as Linux
    platforms = lib.platforms.linux;
  };
}

