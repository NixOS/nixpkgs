{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  gradle_8,
  jre,
  makeWrapper,
  nix-update-script,
  runCommand,
  versionCheckHook,
  writeText,
}:
let
  # "Deprecated Gradle features were used in this build, making it incompatible with Gradle 9.0."
  gradle = gradle_8;
in
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "smithy-cli";
  version = "1.72.1";

  src = fetchFromGitHub {
    owner = "smithy-lang";
    repo = "smithy";
    tag = finalAttrs.version;
    hash = "sha256-IBqh2ATKi5MfaCjvXz7KE2p3lGJa8Sn3YhOuwaW1/sk=";
  };

  strictDeps = true;
  __structuredAttrs = true;

  nativeBuildInputs = [
    gradle
    makeWrapper
  ];

  # Required on Darwin to avoid SocketException during Gradle operations
  __darwinAllowLocalNetworking = true;

  mitmCache = gradle.fetchDeps {
    inherit (finalAttrs) pname;
    data = ./deps.json;
  };

  # Only build the shadowJar for smithy-cli, skip native image tasks that
  # would try to download Amazon Corretto
  gradleBuildTask = ":smithy-cli:shadowJar";

  # Fetch both compile and test dependencies during update
  gradleUpdateTask = ":smithy-cli:shadowJar :smithy-cli:test";

  doCheck = true;
  gradleCheckTask = ":smithy-cli:test";

  installPhase = ''
    runHook preInstall

    mkdir -p $out/{bin,share/smithy-cli/lib}

    # Install the shadow JAR along with the Smithy dependency JARs that it
    # deliberately excludes (they are expected on the classpath separately).
    # smithy-syntax uses the shadow plugin too, so its shaded JAR also replaces
    # the plain one rather than gaining a classifier.
    for proj in smithy-cli smithy-utils smithy-model smithy-build smithy-diff smithy-syntax; do
      cp $proj/build/libs/$proj-${finalAttrs.version}.jar $out/share/smithy-cli/lib/
    done

    makeWrapper ${lib.getExe jre} $out/bin/smithy \
      --set CLASSPATH "$out/share/smithy-cli/lib/*" \
      --add-flags "software.amazon.smithy.cli.SmithyCli"

    runHook postInstall
  '';

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  passthru = {
    updateScript = nix-update-script { };

    tests.validate = runCommand "smithy-cli-validate-test" { } ''
      ${lib.getExe finalAttrs.finalPackage} validate ${writeText "example.smithy" ''
        $version: "2.0"
        namespace example
        service ExampleService {
            version: "2023-01-01"
            operations: [GetUser]
        }
        operation GetUser {
            input: GetUserInput
            output: GetUserOutput
        }
        structure GetUserInput {
            @required
            userId: String
        }
        structure GetUserOutput {
            @required
            name: String
        }
      ''}
      touch $out
    '';
  };

  meta = {
    description = "CLI for the Smithy interface definition language (IDL)";
    homepage = "https://smithy.io/";
    changelog = "https://github.com/smithy-lang/smithy/releases/tag/${finalAttrs.version}";
    sourceProvenance = with lib.sourceTypes; [
      fromSource
      binaryBytecode # deps
    ];
    license = lib.licenses.asl20;
    mainProgram = "smithy";
    maintainers = [ lib.maintainers.joshgodsiff ];
    inherit (jre.meta) platforms;
  };
})
