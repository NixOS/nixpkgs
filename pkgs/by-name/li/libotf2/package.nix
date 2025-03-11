{
  lib,
  stdenv,
  fetchurl,
  buildPackages,
  autoreconfHook,
  which,
  sphinx,
  python3,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libotf2";
  version = "3.1";

  outputs = [
    "out"
    "lib"
    "doc"
  ];

  src = fetchurl {
    url = "https://perftools.pages.jsc.fz-juelich.de/cicd/otf2/tags/otf2-${finalAttrs.version}/otf2-${finalAttrs.version}.tar.gz";
    hash = "sha256-Cd/y7aaSSGuIrV7hibvJ1+vB8XyGMQjETM+WMbrbraQ=";
  };

  postPatch = ''
    substituteInPlace build-backend/Makefile.in \
      --replace-fail 'am__v_pyc_0 = --silent' "" \
      --replace-fail 'am__v_pyc_1 = ' ""
    substituteInPlace build-frontend/Makefile.in \
      --replace-fail 'am__v_pyc_0 = --silent' "" \
      --replace-fail 'am__v_pyc_1 = ' ""
    substituteInPlace build-config/common/platforms/platform-backend-user-provided \
      --replace-fail 'CC=' 'CC=${stdenv.cc.targetPrefix}cc' \
      --replace-fail 'CXX=' 'CXX=${stdenv.cc.targetPrefix}c++'
    substituteInPlace build-config/common/platforms/platform-frontend-user-provided \
      --replace-fail 'CC_FOR_BUILD=' 'CC_FOR_BUILD=${buildPackages.stdenv.cc.targetPrefix}cc' \
      --replace-fail 'CXX_FOR_BUILD=' 'CXX_FOR_BUILD=${buildPackages.stdenv.cc.targetPrefix}c++'
  '';

  depsBuildBuild = [ buildPackages.stdenv.cc ];

  strictDeps = true;
  enableParallelBuilding = true;

  configureFlags =
    [
      (lib.enableFeature finalAttrs.finalPackage.doCheck "backend-test-runs")
      (lib.withFeature true "custom-compilers")
    ]
    ++ lib.optionals (!lib.systems.equals stdenv.buildPlatform stdenv.hostPlatform) [
      "ac_scorep_cross_compiling=yes"
    ];

  nativeBuildInputs = [
    autoreconfHook
    which
    sphinx
  ];

  buildInputs = [
    python3
  ];

  doCheck = true;
  enableParallelChecking = true;

  meta = {
    description = "Highly scalable, memory efficient event trace data format plus support library";
    homepage = "https://www.vi-hps.org/projects/score-p";
    license = lib.licenses.bsd3;
    maintainers = [ lib.maintainers.xokdvium ];
  };
})
