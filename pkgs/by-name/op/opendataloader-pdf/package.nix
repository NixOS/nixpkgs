{
  lib,
  maven,
  fetchFromGitHub,
  makeBinaryWrapper,
  jre,
}:

maven.buildMavenPackage rec {
  pname = "opendataloader-pdf";
  version = "2.2.1";

  strictDeps = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "opendataloader-project";
    repo = "opendataloader-pdf";
    tag = "v${version}";
    hash = "sha256-5ZuVe5QIUyklNi7+pWUuUwoOHs/zv9Yv8EAkww0O7tA=";
  };

  sourceRoot = "${src.name}/java";

  mvnHash = "sha256-op4c5bHt2TY3+aq9oBOhzpyay9Yajo4/Btm0Pscyvzk=";
  mvnParameters = "-Dproject.build.outputTimestamp=1980-01-01T00:00:02Z";

  nativeBuildInputs = [
    makeBinaryWrapper
  ];

  installPhase = ''
    runHook preInstall

    install -Dm644 opendataloader-pdf-cli/target/opendataloader-pdf-cli-0.0.0.jar $out/share/opendataloader-pdf-cli/opendataloader-pdf-cli.jar

    mkdir -p $out/bin
    makeWrapper ${lib.getExe jre} $out/bin/${meta.mainProgram} \
      --add-flags "-jar $out/share/opendataloader-pdf-cli/opendataloader-pdf-cli.jar"

    runHook postInstall
  '';

  meta = {
    description = "PDF Parser for AI-ready data";
    homepage = "https://github.com/opendataloader-project/opendataloader-pdf";
    changelog = "https://github.com/opendataloader-project/opendataloader-pdf/blob/${src.tag}/CHANGELOG.md";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ drupol ];
    mainProgram = "opendataloader-pdf";
    platforms = lib.platforms.linux;
  };
}
