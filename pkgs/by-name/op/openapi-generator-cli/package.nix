{
  callPackage,
  lib,
  jre_headless,
  fetchFromGitHub,
  fetchpatch,
  maven,
  makeWrapper,
  nix-update-script,
}:

let
  jre = jre_headless;
  version = "7.21.0";
  mainProgram = "openapi-generator-cli";
  this = maven.buildMavenPackage {
    inherit version;

    pname = "openapi-generator-cli";

    src = fetchFromGitHub {
      owner = "OpenAPITools";
      repo = "openapi-generator";
      tag = "v${version}";
      hash = "sha256-3e2JrZ+k88t3CyrkBzwkijs0yZGGwB9Se2CeSB02x6c=";
    };

    patches = [
      # Achieve reproducible mvnHash by pinning develocity plugin.
      (fetchpatch {
        url = "https://github.com/OpenAPITools/openapi-generator/commit/ff66e1bc7fe33dcee89de7296eb7bcd5e2a11cc6.patch";
        hash = "sha256-E1VgtaIW1V+8ch2RpW850fVNl5Iqitjog+0b8DKFgZw=";
      })
    ];

    mvnHash = "sha256-iWVWVEiwvCwc0ayVjH9joiDchyyNUOhEZjJTMH9CCEE=";
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

    passthru = {
      updateScript = nix-update-script { };
      tests.example = callPackage ./example.nix {
        openapi-generator-cli = this;
      };
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
