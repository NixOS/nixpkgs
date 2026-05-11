{
  lib,
  stdenv,
  fetchFromGitHub,
  gradle,
  jdk,
  jre,
  makeWrapper,
  testers,
  runCommand,
  writeText,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "smithy-cli";
  version = "1.68.0";

  src = fetchFromGitHub {
    owner = "smithy-lang";
    repo = "smithy";
    tag = finalAttrs.version;
    hash = "sha256-jME/yF6i+hQFMr8lseRKS8uSv0s6HNWqBfsRuSSzonI=";
  };

  nativeBuildInputs = [
    gradle
    jdk
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

    mkdir -p $out/share/smithy-cli/lib $out/bin

    # Install the shadow JAR and the Smithy dependency JARs that it
    # deliberately excludes (they are expected on the classpath separately)
    cp smithy-cli/build/libs/smithy-cli-${finalAttrs.version}.jar $out/share/smithy-cli/lib/
    for proj in smithy-utils smithy-model smithy-build smithy-diff; do
      cp $proj/build/libs/$proj-${finalAttrs.version}.jar $out/share/smithy-cli/lib/
    done
    # smithy-syntax uses the shadow plugin too, so its JAR has no classifier
    cp smithy-syntax/build/libs/smithy-syntax-${finalAttrs.version}.jar $out/share/smithy-cli/lib/

    # Create wrapper that puts all JARs on the classpath.
    # Java's -cp wildcard syntax requires a literal '*' (not shell-expanded),
    # so we construct the classpath explicitly.
    classpath=$(find $out/share/smithy-cli/lib -name '*.jar' | tr '\n' ':' | sed 's/:$//')
    makeWrapper ${lib.getExe jre} $out/bin/smithy \
      --add-flags "-cp $classpath software.amazon.smithy.cli.SmithyCli"

    runHook postInstall
  '';

  passthru.tests = {
    version = testers.testVersion {
      package = finalAttrs.finalPackage;
    };
    validate = runCommand "smithy-cli-validate-test" { } ''
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
    platforms = lib.platforms.unix;
  };
})
