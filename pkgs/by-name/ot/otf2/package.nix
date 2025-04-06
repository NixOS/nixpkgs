{
  lib,
  stdenv,
  fetchurl,
  versionCheckHook,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "otf2";
  version = "3.1.1";

  src = fetchurl {
    url = "http://perftools.pages.jsc.fz-juelich.de/cicd/otf2/tags/otf2-${finalAttrs.version}/otf2-${finalAttrs.version}.tar.gz";
    hash = "sha256-Wk4BOlGsTteU/jXFW3AM1yA0b9p/M+yEx2uGpfuICm4=";
  };

  configureFlags = [
    "--enable-backend-test-runs"
  ];

  nativeInstallCheckInputs = [ versionCheckHook ];

  doCheck = true;
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
