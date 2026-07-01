{
  lib,
  maven,
  fetchFromGitHub,
  makeBinaryWrapper,
  jre,
}:

maven.buildMavenPackage (finalAttrs: {
  pname = "opendataloader-pdf";
  version = "2.4.7";

  strictDeps = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "opendataloader-project";
    repo = "opendataloader-pdf";
    tag = "v${finalAttrs.version}";
    hash = "sha256-qCU0Yb4N0KtbqVSscGLmv0xps4RwR++WxS/A44WwRlk=";
  };

  sourceRoot = "${finalAttrs.src.name}/java";

  mvnHash = "sha256-LK673DYibhntPsHXvCM676ZzsE7tYIWPlQ2LFoCVvpc=";
  mvnParameters = "-Dproject.build.outputTimestamp=1980-01-01T00:00:02Z";

  nativeBuildInputs = [
    makeBinaryWrapper
  ];

  installPhase = ''
    runHook preInstall

    install -Dm644 opendataloader-pdf-cli/target/opendataloader-pdf-cli-0.0.0.jar $out/share/opendataloader-pdf-cli/opendataloader-pdf-cli.jar

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
