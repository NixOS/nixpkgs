{
  stdenv,
  lib,
  fetchFromGitHub,
  gitUpdater,
  testers,
  withDocumentation ? true,
  autoreconfHook,
  doxygen,
  graphviz,
  makeFontsConf,
  writableTmpDirAsHomeHook,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libresidfp";
  version = "1.2.1";

  src = fetchFromGitHub {
    owner = "libsidplayfp";
    repo = "libresidfp";
    tag = "v${finalAttrs.version}";
    hash = "sha256-0XxQtXRHHEW7DNPKFu345ffiwo949uIDeL2oj2f8+jY=";
  };

  strictDeps = true;
  __structuredAttrs = true;

  outputs = [
    "out"
    "dev"
  ]
  ++ lib.optionals withDocumentation [
    "doc"
  ];

  nativeBuildInputs = [
    autoreconfHook
  ]
  ++ lib.optionals withDocumentation [
    doxygen
    graphviz
    writableTmpDirAsHomeHook
  ];

  configureFlags = [
    # Supposedly runtime detection only supported on GCC
    # __builtin_cpu_supports on GCC's list of x86 built-in functions
    (lib.strings.withFeatureAs true "simd" (
      if (stdenv.cc.isGNU && stdenv.hostPlatform.isx86) then "runtime" else "none"
    ))
    (lib.strings.enableFeature finalAttrs.finalPackage.doCheck "tests")
  ];

  enableParallelBuilding = true;

  buildFlags = [
    "all"
  ]
  ++ lib.optionals withDocumentation [
    "doc"
  ];

  doCheck = stdenv.buildPlatform.canExecute stdenv.hostPlatform;

  postInstall = lib.optionalString withDocumentation ''
    mkdir -p $doc/share/doc/
    mv docs/html $doc/share/doc/libresidfp
  '';

  env = lib.optionalAttrs withDocumentation {
    FONTCONFIG_FILE = makeFontsConf {
      fontDirectories = [ ];
    };
  };

  passthru = {
    tests.pkg-config = testers.hasPkgConfigModules {
      package = finalAttrs.finalPackage;
      versionCheck = true;
    };
    updateScript = gitUpdater {
      rev-prefix = "v";
      ignoredVersions = "[a-zA-Z]";
    };
  };

  meta = {
    description = "Cycle exact SID emulation";
    homepage = "https://github.com/libsidplayfp/libresidfp";
    changelog = "https://github.com/libsidplayfp/libresidfp/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.gpl2Plus;
    maintainers = [ lib.maintainers.OPNA2608 ];
    platforms = lib.platforms.all;
    pkgConfigModules = [
      "libresidfp"
    ];
  };
})
