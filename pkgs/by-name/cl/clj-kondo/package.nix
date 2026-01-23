{
  lib,
  buildGraalvmNativeImage,
  fetchurl,
}:

buildGraalvmNativeImage (finalAttrs: {
  pname = "clj-kondo";
  version = "2025.10.23";

  src = fetchurl {
    url = "https://github.com/clj-kondo/clj-kondo/releases/download/v${finalAttrs.version}/clj-kondo-${finalAttrs.version}-standalone.jar";
    sha256 = "sha256-bqHCDPL0R/Or6xHb5QDaw32S+Q2hAly3H5BUbQMDU0M=";
  };

  extraNativeImageBuildArgs = [
    "-H:+ReportExceptionStackTraces"
    "--no-fallback"
  ];

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
