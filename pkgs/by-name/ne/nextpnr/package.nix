{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  boost,
  python3,
  eigen,
  python3Packages,
  icestorm,
  trellis,
  llvmPackages,
  prjoxide,
  qt6,

  enableGui ? false,

  # Notes:
  # The mistral architecture is excluded as it no longer compiles with the most recent nextpnr
  # The xilinx uarchitecture is packaged separately due to needing vivado see: nextpnr-xilinx
  architectures ? [
    "ice40"
    "ecp5"
    "nexus"
    "generic"

    # The following uarchitectures are under the himbaechel architecture
    "gowin"
    "ng-ultra"
    "gatemate"
    "example"
  ],
}:

let
  boostPython = boost.override {
    python = python3;
    enablePython = true;
  };

  prjbeyond_src = fetchFromGitHub {
    owner = "YosysHQ-GmbH";
    repo = "prjbeyond-db";
    rev = "f49f66be674d9857c657930353b867ba94bcbdd7";
    hash = "sha256-B/VmKgMu6f2Y8umE+NgGD5W0FYBIfDcMVwgHocFzreA=";
  };

  prjpeppercorn_src = fetchFromGitHub {
    owner = "YosysHQ";
    repo = "prjpeppercorn";
    tag = "v1.13";
    hash = "sha256-vlwb/lWVUUdI95GPE887jque7WmNWtBSxSIRcK6k7cU=";
  };

  uArches = [
    "gowin"
    "ng-ultra"
    "gatemate"
    "example"
  ];
  selectedUArches = lib.intersectLists uArches architectures;

  majorArches = [
    "ice40"
    "ecp5"
    "nexus"
    "generic"
    "himbaechel"
  ];
  selectedArches = lib.intersectLists majorArches (
    architectures ++ lib.optional (selectedUArches != [ ]) "himbaechel"
  );

  hasArch = arch: output: lib.optionals (lib.elem arch selectedArches) output;
  hasUArch = arch: output: lib.optionals (lib.elem arch selectedUArches) output;
in

stdenv.mkDerivation (finalAttrs: {
  pname = "nextpnr";
  version = "0.11.1";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "YosysHQ";
    repo = "nextpnr";
    tag = "nextpnr-${finalAttrs.version}";
    hash = "sha256-Lh4ByqfFKNK641tT33OWaAqjlbBDvtE1AUCQ4mRiWiU=";
    fetchSubmodules = true;
    leaveDotGit = true;
    postFetch = "rm -rf $out/.git";
  };

  checkValidArch =
    if selectedArches == [ ] then
      lib.throw ''
        No valid architecture selected! Please enable at least one of the following
          [ ice40 ecp5 nexus generic gowin ng-ultra gatemate example ]
      ''
    else
      "";

  nativeBuildInputs = [
    cmake
    python3
  ]
  ++ lib.optionals enableGui [
    qt6.wrapQtAppsHook
    qt6.qtbase.dev
  ];

  buildInputs = [
    boostPython
    eigen
    python3Packages.apycula
  ]
  ++ lib.optionals enableGui [
    qt6.qtbase
    qt6.qtwayland
  ]
  ++ lib.optionals stdenv.cc.isClang [ llvmPackages.openmp ];

  cmakeFlags = [
    (lib.cmakeFeature "CURRENT_GIT_VERSION" finalAttrs.version)
    (lib.cmakeFeature "ARCH" (lib.strings.concatStringsSep ";" selectedArches))
    (lib.cmakeBool "BUILD_TESTS" true)
    (lib.cmakeBool "USE_OPENMP" true)

    (lib.cmakeBool "BUILD_GUI" enableGui)
  ]
  ++ hasArch "ice40" [
    (lib.cmakeFeature "ICESTORM_INSTALL_PREFIX" icestorm.outPath)
  ]
  ++ hasArch "ecp5" [
    (lib.cmakeFeature "TRELLIS_INSTALL_PREFIX" trellis.outPath)
    (lib.cmakeFeature "TRELLIS_LIBDIR" "${lib.getLib trellis}/lib/trellis")
  ]
  ++ hasArch "nexus" [
    (lib.cmakeFeature "OXIDE_INSTALL_PREFIX" prjoxide.outPath)
  ]
  ++ hasArch "himbaechel" [
    (lib.cmakeFeature "HIMBAECHEL_UARCH" (lib.strings.concatStringsSep ";" selectedUArches))
  ]
  ++ hasUArch "gowin" [
    (lib.cmakeFeature "HIMBAECHEL_GOWIN_DEVICES" "all")
  ]
  ++ hasUArch "ng-ultra" [
    (lib.cmakeFeature "HIMBAECHEL_PRJBEYOND_DB" prjbeyond_src.outPath)
  ]
  ++ hasUArch "gatemate" [
    (lib.cmakeFeature "HIMBAECHEL_PEPPERCORN_PATH" prjpeppercorn_src.outPath)
  ];

  doCheck = true;

  strictDeps = true;

  meta = {
    description = "Place and route tool for FPGAs";
    homepage = "https://github.com/yosyshq/nextpnr";
    changelog = "https://github.com/YosysHQ/nextpnr/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.isc;
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [
      thoughtpolice
      gitRaiku
    ];
  };
})
