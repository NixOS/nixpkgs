{
  lib,
  buildGraalvmNativeImage,
  fetchurl,
  versionCheckHook,
}:

buildGraalvmNativeImage (finalAttrs: {
  pname = "clj-kondo";
  version = "2026.08.04";

  src = fetchurl {
    url = "https://github.com/clj-kondo/clj-kondo/releases/download/v${finalAttrs.version}/clj-kondo-${finalAttrs.version}-standalone.jar";
    sha256 = "sha256-iElpFiQzzKwbYKi7gIRXc81C38ix3s4vvuEwcP0gos0=";
  };

  extraNativeImageBuildArgs = [
    "-H:+ReportExceptionStackTraces"
    "--no-fallback"
    # GraalVM >= 25.1 removed @AutomaticFeature discovery, so the bundled
    # graal-build-time feature no longer runs and the binary crashes at
    # startup. Register it explicitly. Remove once a release carrying
    # https://github.com/clj-kondo/clj-kondo/pull/2949 is packaged.
    "--features=InitAtBuildTimeFeature"
  ];

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];

  meta = {
    description = "Linter for Clojure code that sparks joy";
    homepage = "https://github.com/clj-kondo/clj-kondo";
    sourceProvenance = with lib.sourceTypes; [ binaryBytecode ];
    license = lib.licenses.epl10;
    changelog = "https://github.com/clj-kondo/clj-kondo/blob/v${finalAttrs.version}/CHANGELOG.md";
    maintainers = with lib.maintainers; [
      jlesquembre
      bandresen
    ];
    mainProgram = "clj-kondo";
  };
})
