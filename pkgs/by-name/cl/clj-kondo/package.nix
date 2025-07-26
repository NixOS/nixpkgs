{
  lib,
  buildGraalvmNativeImage,
  fetchurl,
}:

buildGraalvmNativeImage (finalAttrs: {
  pname = "clj-kondo";
  version = "2025.07.26";

  src = fetchurl {
    url = "https://github.com/clj-kondo/clj-kondo/releases/download/v${finalAttrs.version}/clj-kondo-${finalAttrs.version}-standalone.jar";
    sha256 = "sha256-jo8iY8vEtrGTQTV98y89i2OLWW4M3u6hsXZebd7cnUw=";
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
