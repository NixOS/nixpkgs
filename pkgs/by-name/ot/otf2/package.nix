{
  lib,
  stdenv,
  fetchurl,
  buildPackages,
  which,
  versionCheckHook,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "otf2";
  version = "3.1.1";

  outputs = [
    "out"
    "lib"
    "doc"
  ];

  src = fetchurl {
    url = "http://perftools.pages.jsc.fz-juelich.de/cicd/otf2/tags/otf2-${finalAttrs.version}/otf2-${finalAttrs.version}.tar.gz";
    hash = "sha256-Wk4BOlGsTteU/jXFW3AM1yA0b9p/M+yEx2uGpfuICm4=";
  };

  postPatch = ''
    substituteInPlace build-config/common/platforms/platform-backend-user-provided \
      --replace-fail 'CC=' 'CC=${stdenv.cc.targetPrefix}cc' \
      --replace-fail 'CXX=' 'CXX=${stdenv.cc.targetPrefix}c++'
    substituteInPlace build-config/common/platforms/platform-frontend-user-provided \
      --replace-fail 'CC_FOR_BUILD=' 'CC_FOR_BUILD=${buildPackages.stdenv.cc.targetPrefix}cc' \
      --replace-fail 'CXX_FOR_BUILD=' 'CXX_FOR_BUILD=${buildPackages.stdenv.cc.targetPrefix}c++'
  '';

  strictDeps = true;
  depsBuildBuild = [ buildPackages.stdenv.cc ];

  configureFlags = [
    (lib.enableFeature finalAttrs.finalPackage.doCheck "backend-test-runs")
    (lib.withFeature true "custom-compilers")
  ]
  ++ lib.optionals (!lib.systems.equals stdenv.buildPlatform stdenv.hostPlatform) [
    "ac_scorep_cross_compiling=yes"
  ];

  nativeBuildInputs = [
    which # used in configure script
  ];

  enableParallelBuilding = true;

  nativeInstallCheckInputs = [ versionCheckHook ];

  doCheck = true;
  enableParallelChecking = true;
  doInstallCheck = true;

  versionCheckProgram = [ "${placeholder "out"}/bin/otf2-config" ];

  meta = {
    homepage = "https://www.vi-hps.org/projects/score-p";
    changelog = "https://perftools.pages.jsc.fz-juelich.de/cicd/otf2/tags/otf2-${finalAttrs.version}/ChangeLog.txt";
    description = "Open Trace Format 2 library";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ lesuisse ];
  };
})
