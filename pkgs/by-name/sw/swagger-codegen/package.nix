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
  version = "2.4.52";

  src = fetchFromGitHub {
    owner = "swagger-api";
    repo = "swagger-codegen";
    tag = "v${version}";
    hash = "sha256-IClfRF2U4HhtAKoeeg+J7hwnNMF2aRY6BCKM2qg3m9w=";
  };

  mvnHash = "sha256-zuYMCX5OfRQ2o1KfEiKx87d0re+94tN6wI6VOTQna88=";

  mvnParameters = toString [
    "-pl modules/swagger-codegen-cli"
    "-am"
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
