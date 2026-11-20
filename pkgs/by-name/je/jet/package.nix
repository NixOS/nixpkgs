{
  lib,
  buildGraalvmNativeImage,
  fetchurl,
  testers,
}:

buildGraalvmNativeImage (finalAttrs: {
  pname = "jet";
  version = "0.7.27";

  src = fetchurl {
    url = "https://github.com/borkdude/jet/releases/download/v${finalAttrs.version}/jet-${finalAttrs.version}-standalone.jar";
    sha256 = "sha256-250/1DBNCXlU1b4jjLUUOXI+uSbOyPXtBN1JJRpdmFc=";
  };

  extraNativeImageBuildArgs = [
    "-H:+ReportExceptionStackTraces"
    "-H:Log=registerResource:"
    "--no-fallback"
    "--no-server"
    "-J-Djet.native=true"
    # GraalVM >= 25.1 no longer discovers @AutomaticFeature annotations.
    "--features=InitAtBuildTimeFeature"
  ];

  doInstallCheck = true;
  installCheckPhase = ''
    runHook preInstallCheck

    output="$(
      printf '%s\n' '{"value":1}' \
        | $out/bin/jet --from json --to edn --keywordize
    )"
    test "$output" = '{:value 1}'

    runHook postInstallCheck
  '';

  passthru.tests.version = testers.testVersion {
    inherit (finalAttrs) version;
    package = finalAttrs.finalPackage;
    command = "jet --version";
  };

  meta = {
    description = "CLI to transform between JSON, EDN, YAML and Transit, powered with a minimal query language";
    homepage = "https://github.com/borkdude/jet";
    sourceProvenance = with lib.sourceTypes; [ binaryBytecode ];
    license = lib.licenses.epl10;
    maintainers = with lib.maintainers; [ ericdallo ];
    mainProgram = "jet";
  };
})
