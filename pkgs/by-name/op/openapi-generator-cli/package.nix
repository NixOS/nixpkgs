{
  callPackage,
  lib,
  jre_headless,
  fetchFromGitHub,
  maven,
  makeWrapper,
}:

let
  jre = jre_headless;
  version = "7.15.0";
  mainProgram = "openapi-generator-cli";
  this = maven.buildMavenPackage {
    inherit version;

    pname = "openapi-generator-cli";

    src = fetchFromGitHub {
      owner = "OpenAPITools";
      repo = "openapi-generator";
      tag = "v${version}";
      hash = "sha256-IgjlMOHMASijIt5nMqOZcUpxecbWljHh9rA1YUwUmwM=";
    };

    mvnHash = "sha256-woHPf7vPja70cNj6Glqr0OGAR8CV8qWiRu0hkmCcCrA=";
    mvnParameters = "-Duser.home=$TMPDIR";
    doCheck = false;

    # Otherwise, Gradle fails with `java.net.SocketException: Operation not permitted`
    __darwinAllowLocalNetworking = true;

    nativeBuildInputs = [
      makeWrapper
    ];

    installPhase = ''
      runHook preInstall

      mkdir -p $out/bin $out/share/java
      jarfilename=$out/share/java/openapi-generator-cli.jar
      install -Dm644 modules/openapi-generator-cli/target/openapi-generator-cli.jar $jarfilename

      makeWrapper ${jre}/bin/java $out/bin/${mainProgram} \
        --add-flags "-jar $jarfilename"

      runHook postInstall
    '';

    passthru.tests.example = callPackage ./example.nix {
      openapi-generator-cli = this;
    };

    meta = {
      description = "Allows generation of API client libraries (SDK generation), server stubs and documentation automatically given an OpenAPI Spec";
      homepage = "https://github.com/OpenAPITools/openapi-generator";
      changelog = "https://github.com/OpenAPITools/openapi-generator/releases/tag/v${version}";
      sourceProvenance = with lib.sourceTypes; [ binaryBytecode ];
      license = lib.licenses.asl20;
      maintainers = with lib.maintainers; [
        booxter
        shou
      ];
      inherit mainProgram;
    };
  };
in
this
