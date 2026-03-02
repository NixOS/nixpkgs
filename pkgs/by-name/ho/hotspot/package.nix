{
  lib,
  stdenv,
  binutils,
  cmake,
  patchelfUnstable,
  elfutils,
  fetchFromGitHub,
  fetchpatch,
  kddockwidgets,
  kdePackages,
  libelf,
  perf,
  qt6,
  rustc-demangle,
  zstd,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "hotspot";
  version = "1.5.1";

  src = fetchFromGitHub {
    owner = "KDAB";
    repo = "hotspot";
    tag = "v${finalAttrs.version}";
    hash = "sha256-O2wp19scyHIwIY2AzKmPmorGXDH249/OhSg+KtzOYhI=";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [
    cmake
    kdePackages.extra-cmake-modules
    # stable patchelf corrupts the binary
    patchelfUnstable
    qt6.wrapQtAppsHook
  ];

  patches = [
    # Fix build issue with Qt 6.9, can be removed in next release
    (fetchpatch {
      url = "https://github.com/KDAB/hotspot/pull/694/commits/5ef04c1dd60846b0d1746132e7e63289ee25f259.patch";
      hash = "sha256-WYMM1/CY05fztSiRNZQ2Q16n5erjY+AE6gSQgSlb3HA=";
    })
  ];

  cmakeFlags = [ (lib.strings.cmakeBool "QT6_BUILD" true) ];

  buildInputs = [
    (elfutils.override { enableDebuginfod = true; }) # perfparser needs to find debuginfod.h
    kddockwidgets
    libelf
    qt6.qtbase
    qt6.qtsvg
    rustc-demangle
    zstd
  ]
  ++ (with kdePackages; [
    kconfig
    kconfigwidgets
    kgraphviewer
    ki18n
    kio
    kitemmodels
    kitemviews
    konsole
    kparts
    kwindowsystem
    qcustomplot
    syntax-highlighting
    threadweaver
  ]);

  qtWrapperArgs = [
    "--suffix PATH : ${
      lib.makeBinPath [
        perf
        binutils
      ]
    }"
  ];

  preFixup = ''
    patchelf \
      --add-rpath ${lib.makeLibraryPath [ rustc-demangle ]} \
      --add-needed librustc_demangle.so \
      $out/libexec/hotspot-perfparser
  '';

  meta = {
    description = "GUI for Linux perf";
    mainProgram = "hotspot";
    longDescription = ''
      hotspot is a GUI replacement for `perf report`.
      It takes a perf.data file, parses and evaluates its contents and
      then displays the result in a graphical way.
    '';
    homepage = "https://github.com/KDAB/hotspot";
    changelog = "https://github.com/KDAB/hotspot/releases/tag/v${finalAttrs.version}";
    license = with lib.licenses; [
      gpl2Only
      gpl3Only
    ];
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [
      nh2
      tmarkus
    ];
  };
})
