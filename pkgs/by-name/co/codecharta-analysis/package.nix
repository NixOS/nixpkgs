{
  lib,
  stdenv,
  fetchFromGitHub,
  coreutils,
  findutils,
  gnused,
  gradle_9,
  gitMinimal,
  jdk25_headless,
  makeWrapper,
  versionCheckHook,
  writeShellApplication,
  nix-update,
}:

let
  gradle = gradle_9;
  # ccsh needs Java 22 or newer at runtime
  jre = jdk25_headless;
in
stdenv.mkDerivation (finalAttrs: {
  pname = "codecharta-analysis";
  version = "2.4.0";

  src = fetchFromGitHub {
    owner = "MaibornWolff";
    repo = "codecharta";
    tag = "ana-${finalAttrs.version}";
    hash = "sha256-lb9syItpO0EWyLFMynH8BGIRV9RWRCz3JHIpwdp+dfs=";
  };

  sourceRoot = "${finalAttrs.src.name}/analysis";

  # foojay only auto-provisions JDKs; Gradle already runs on the JDK 25 toolchain
  postPatch = ''
    substituteInPlace settings.gradle.kts \
      --replace-fail 'id("org.gradle.toolchains.foojay-resolver-convention") version "1.0.0"' ""

    # these tests scan the source checkout itself, which is no git repository
    cat >> analysers/parsers/GitLogParser/build.gradle.kts <<'EOF'

    tasks.test {
        filter {
            excludeTestsMatching("*GitLogParserTest.*repo-scan*")
            excludeTestsMatching("*GitAdapterTest.should produce a*")
        }
    }
    EOF
  '';

  nativeBuildInputs = [
    gradle
    makeWrapper
  ];

  mitmCache = gradle.fetchDeps {
    inherit (finalAttrs) pname;
    data = ./deps.json;
  };

  __darwinAllowLocalNetworking = true;

  # The root project's distribution bundles bin/ccsh and the ccsh fat jar
  gradleBuildTask = ":installDist";

  gradleFlags = [
    "-Dfile.encoding=utf-8"
    "-Porg.gradle.java.installations.auto-download=false"
    # gradle.properties enables configure on demand, which leaves the ccsh
    # project unconfigured for :installDist and its bin and lib out of the distribution
    "--no-configure-on-demand"
    # the test task is finalized by the coverage report, which we don't need
    "-x"
    "jacocoTestReport"
  ];

  doCheck = true;

  # many tests create and inspect temporary git repositories
  nativeCheckInputs = [ gitMinimal ];

  preCheck = ''
    export LANG=C.UTF-8
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/codecharta-analysis
    cp -r build/install/codecharta-analysis/{bin,lib} $out/share/codecharta-analysis/

    makeWrapper $out/share/codecharta-analysis/bin/ccsh $out/bin/ccsh \
      --set-default JAVA_HOME ${jre.home} \
      --prefix PATH : ${
        # the Gradle start script calls uname, xargs and sed
        lib.makeBinPath [
          coreutils
          findutils
          gnused
        ]
      }

    runHook postInstall
  '';

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;
  versionCheckProgramArg = "--version";

  passthru.updateScript = lib.getExe (writeShellApplication {
    name = "codecharta-analysis-update";
    runtimeInputs = [ nix-update ];
    text = ''
      nix-update --version-regex 'ana-(.*)' codecharta-analysis
      eval "$(nix-build --no-out-link -A codecharta-analysis.mitmCache.updateScript)"
    '';
  });

  meta = {
    description = "Command line tools to import and analyze code metrics for CodeCharta";
    homepage = "https://codecharta.com";
    changelog = "https://github.com/MaibornWolff/codecharta/blob/ana-${finalAttrs.version}/analysis/CHANGELOG.md";
    license = lib.licenses.bsd3;
    mainProgram = "ccsh";
    maintainers = with lib.maintainers; [ matthiasbeyer ];
    sourceProvenance = with lib.sourceTypes; [
      fromSource
      binaryBytecode # mitm cache
      binaryNativeCode # tree-sitter grammar jars bundle prebuilt shared libraries
    ];
    # the bundled tree-sitter libraries only exist for these platforms
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
      "x86_64-darwin"
      "aarch64-darwin"
    ];
  };
})
