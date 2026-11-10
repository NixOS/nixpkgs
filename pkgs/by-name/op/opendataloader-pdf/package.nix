{
  lib,
  maven,
  fetchFromGitHub,
  makeBinaryWrapper,
  jre,
}:

maven.buildMavenPackage (finalAttrs: {
  pname = "opendataloader-pdf";
  version = "2.5.20";

  strictDeps = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "opendataloader-project";
    repo = "opendataloader-pdf";
    tag = "v${finalAttrs.version}";
    hash = "sha256-LMeQY+/heCP7s7u6piiWmg/K3XuytVED1Yro00PUQ/o=";
  };

  sourceRoot = "${finalAttrs.src.name}/java";

  mvnHash = "sha256-U3B8KxCna0V/WMbygd0BYoDcMTBhTHvVlDuISUwIdes=";
  mvnParameters = "-Dproject.build.outputTimestamp=1980-01-01T00:00:02Z";

  nativeBuildInputs = [
    makeBinaryWrapper
  ];

  installPhase = ''
    runHook preInstall

    install -Dm644 opendataloader-pdf-cli/target/opendataloader-pdf-cli-${finalAttrs.version}-SNAPSHOT.jar $out/share/opendataloader-pdf-cli/opendataloader-pdf-cli.jar

    mkdir -p $out/bin
    makeWrapper ${lib.getExe jre} $out/bin/${finalAttrs.meta.mainProgram} \
      --add-flags "-jar $out/share/opendataloader-pdf-cli/opendataloader-pdf-cli.jar"

    runHook postInstall
  '';

  meta = {
    description = "PDF Parser for AI-ready data";
    homepage = "https://github.com/opendataloader-project/opendataloader-pdf";
    changelog = "https://github.com/opendataloader-project/opendataloader-pdf/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ drupol ];
    mainProgram = "opendataloader-pdf";
    platforms = lib.platforms.linux;
  };
})
