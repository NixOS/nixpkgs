{
  lib,
  buildGraalvmNativeImage,
  fetchurl,
  nix-update-script,
  testers,
}:

buildGraalvmNativeImage (finalAttrs: {
  pname = "cljfmt";
  version = "0.14.0";

  src = fetchurl {
    url = "https://github.com/weavejester/cljfmt/releases/download/${finalAttrs.version}/cljfmt-${finalAttrs.version}-standalone.jar";
    hash = "sha256-A12co+7Ux9rGCcBMRMqwTH7s4hllfs0Ku/+HFQJ4XGE=";
  };

  extraNativeImageBuildArgs = [
    "-H:+ReportExceptionStackTraces"
    "-H:Log=registerResource:"
    "--initialize-at-build-time"
    "--diagnostics-mode"
    "--report-unsupported-elements-at-runtime"
    "--no-fallback"
  ];

  passthru.updateScript = nix-update-script { };

  passthru.tests.version = testers.testVersion {
    inherit (finalAttrs) version;
    package = finalAttrs.finalPackage;
    command = "cljfmt --version";
  };

  meta = {
    mainProgram = "cljfmt";
    description = "Tool for formatting Clojure code";
    homepage = "https://github.com/weavejester/cljfmt";
    sourceProvenance = with lib.sourceTypes; [ binaryBytecode ];
    license = lib.licenses.epl10;
    changelog = "https://github.com/weavejester/cljfmt/blob/${finalAttrs.version}/CHANGELOG.md";
    maintainers = with lib.maintainers; [ sg-qwt ];
  };
})
