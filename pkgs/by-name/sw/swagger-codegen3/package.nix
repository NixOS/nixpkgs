{
  lib,
  maven,
  fetchFromGitHub,
  jre,
  makeWrapper,
  versionCheckHook,
}:

maven.buildMavenPackage rec {
  pname = "swagger-codegen3";
  version = "3.0.77";

  src = fetchFromGitHub {
    owner = "swagger-api";
    repo = "swagger-codegen";
    tag = "v${version}";
    hash = "sha256-TIgn4xyFUoMk5lkYNCK9vl2Z0a46HsC5lIa2QlIBg0w=";
  };

  mvnHash = "sha256-fvzmCLpN3+3D/IZOpJ5ZmraYS+79j9wFiedQmFZ6RIs=";

  mvnParameters = toString [
    "-Dproject.build.outputTimestamp=1980-01-01T00:00:02Z"
  ];

  nativeBuildInputs = [
    makeWrapper
  ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin $out/share/java
    install -Dm644 modules/swagger-codegen-cli/target/swagger-codegen-cli.jar $out/share/java

    makeWrapper ${jre}/bin/java $out/bin/swagger-codegen3 \
      --add-flags "-jar $out/share/java/swagger-codegen-cli.jar"

    runHook postInstall
  '';

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;
  versionCheckProgramArg = "version";

  meta = {
    description = "Allows generation of API client libraries (SDK generation), server stubs and documentation automatically given an OpenAPI Spec";
    homepage = "https://github.com/swagger-api/swagger-codegen/tree/3.0.0";
    changelog = "https://github.com/swagger-api/swagger-codegen/releases/tag/v${version}";
    sourceProvenance = with lib.sourceTypes; [
      fromSource
      binaryBytecode
    ];
    license = lib.licenses.asl20;
    maintainers = [ lib.maintainers._1000101 ];
    mainProgram = "swagger-codegen3";
    platforms = lib.platforms.all;
  };
}
