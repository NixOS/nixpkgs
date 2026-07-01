{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  gradle,
  jdk,
  jre,
  graphviz,
  makeBinaryWrapper,
  testers,
  versionCheckHook,
  nix-update-script,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "plantuml";
  version = "1.2026.6";

  src = fetchFromGitHub {
    owner = "plantuml";
    repo = "plantuml";
    tag = "v${finalAttrs.version}";
    hash = "sha256-p1F84oIp/CGO/nb6uxvP5GRJYog3Fp3EH192IhzNcgs=";
  };

  nativeBuildInputs = [
    gradle
    jdk
    makeBinaryWrapper
  ];

  postPatch = ''
    # Remove unused binary blob (only for windows)
    rm -fv src/main/resources/net/sourceforge/plantuml/windowsdot/graphviz.dat

    # Avoid requiring git
    substituteInPlace build.gradle.kts \
      --replace-fail "gitProperties {" 'gitProperties {
    failOnNoGitDirectory = false'

    # Bake version/commit into CompilationInfo.java directly (patchCompilationInfo
    # is not wired automatically and depends on git.properties)
    substituteInPlace src/main/java/net/sourceforge/plantuml/version/CompilationInfo.java \
      --replace-fail '$version$' '${finalAttrs.version}' \
      --replace-fail '$git.commit.id$' '${finalAttrs.src.rev}'

    # Ignore tests that try to access the internet
    cat >> build.gradle.kts << 'EOF'
    tasks.test {
        filter {
            ${lib.concatStringsSep "\n" (
              map (x: "excludeTestsMatching(\"${x}\")") finalAttrs.excludedTests
            )}
        }
    }
    EOF
  '';

  __darwinAllowLocalNetworking = true;

  mitmCache = gradle.fetchDeps {
    inherit (finalAttrs) pname;
    data = ./deps.json;
  };

  gradleBuildTask = "jar";

  doCheck = true;

  excludedTests = [
    "net.sourceforge.plantuml.nio.PathSystemTest.https_path_contains_title"
  ]
  ++ lib.optionals stdenvNoCC.targetPlatform.isDarwin [
    "net.sourceforge.plantuml.cli.RunStatsTest.testRealTimeXml"
    "net.sourceforge.plantuml.cli.RunStatsTest.testHtml"
    "net.sourceforge.plantuml.cli.RunStatsTest.test1"
    "net.sourceforge.plantuml.cli.RunStatsTest.testRealTimeHtml"
    "net.sourceforge.plantuml.nio.PathSystemTest.tildeHomeExpansion"
    "net.sourceforge.plantuml.nio.RunTildeIncludeTest.tilde_includes_should_resolve_from_user_home"
  ];

  installPhase = ''
    runHook preInstall

    jar=$(find build/libs -name 'plantuml-*.jar' | head -1)
    install -Dm644 "$jar" $out/lib/plantuml.jar

    mkdir -p $out/bin
    makeWrapper ${jre}/bin/java $out/bin/plantuml \
      --argv0 plantuml \
      --set GRAPHVIZ_DOT ${graphviz}/bin/dot \
      --add-flags "-jar $out/lib/plantuml.jar"

    runHook postInstall
  '';

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];

  installCheckPhase = ''
    runHook preInstallCheck

    $out/bin/plantuml -help
    $out/bin/plantuml -testdot

    runHook postInstallCheck
  '';

  # Fix lockfile updater by excluding subprojects that lack (and don't need) nixDownloadDeps
  preGradleUpdate = ''
    gradleFlagsArray+=('-x:plantuml-natif:nixDownloadDeps' '-x:plantuml-mcp-js:nixDownloadDeps')
  '';

  passthru = {
    tests.version = testers.testVersion {
      package = finalAttrs.finalPackage;
      command = "plantuml --version";
    };
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Draw UML diagrams using a simple and human readable text description";
    homepage = "https://plantuml.com/";
    # "plantuml -license" says GPLv3 or later
    license = lib.licenses.gpl3Plus;
    mainProgram = "plantuml";
    maintainers = with lib.maintainers; [
      bjornfor
      anthonyroussel
    ];
    platforms = lib.platforms.unix;
    sourceProvenance = with lib.sourceTypes; [
      fromSource
      binaryBytecode
    ];
  };
})
