{
  lib,
  maven,
  fetchFromGitHub,
  jre,
  makeWrapper,
  versionCheckHook,
}:

maven.buildMavenPackage rec {
  pname = "swagger-codegen";
  version = "2.4.51";

  src = fetchFromGitHub {
    owner = "swagger-api";
    repo = "swagger-codegen";
    tag = "v${version}";
    hash = "sha256-bclFD2Kn5Xn6dxEaS1M69LDUc5lvMLFNFoKZkT1JbVM=";
  };

  mvnHash = "sha256-QyH8AEKX94ieRS6dqFy0QJxwqtpRmnl+E2dJwNLS9kQ=";

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

    makeWrapper ${jre}/bin/java $out/bin/swagger-codegen \
      --add-flags "-jar $out/share/java/swagger-codegen-cli.jar"

    runHook postInstall
  '';

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;
  versionCheckProgramArg = "version";

  meta = {
    description = "Allows generation of API client libraries (SDK generation), server stubs and documentation automatically given an OpenAPI Spec";
    homepage = "https://github.com/swagger-api/swagger-codegen";
    changelog = "https://github.com/swagger-api/swagger-codegen/releases/tag/v${version}";
    sourceProvenance = with lib.sourceTypes; [
      fromSource
      binaryBytecode
    ];
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
      anthonyroussel
      jraygauthier
    ];
    mainProgram = "swagger-codegen";
  };
}
