{
  lib,
  stdenv,
  fetchFromGitHub,
  gradle,
  makeBinaryWrapper,
  jre_headless,
  zulu11,
  nix-update-script,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "gradle-dependency-tree-diff";
  version = "1.2.1";
  src = fetchFromGitHub {
    owner = "JakeWharton";
    repo = "dependency-tree-diff";
    tag = finalAttrs.version;
    hash = "sha256-7ObmZygzSp7aAnqsJuMcPk+I3z993kjHCJMug3JkONg=";
  };

  nativeBuildInputs = [
    gradle
    makeBinaryWrapper
  ];

  mitmCache = gradle.fetchDeps {
    inherit (finalAttrs) pname;
    data = ./deps.json;
  };
  __darwinAllowLocalNetworking = true;

  # There is a requirement on the specific Java toolchain.
  gradleFlags = [ "-Dorg.gradle.java.home=${zulu11}" ];

  gradleBuildTask = "build";
  doCheck = true;

  installPhase = ''
    runHook preInstall

    install -Dm644 build/dependency-tree-diff.jar \
      $out/share/dependency-tree-diff/dependency-tree-diff.jar
    makeWrapper ${lib.getExe jre_headless} $out/bin/dependency-tree-diff \
      --add-flags "-jar $out/share/dependency-tree-diff/dependency-tree-diff.jar"

    runHook postInstall
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Intelligent diff tool for the output of Gradle's dependencies task";
    mainProgram = "dependency-tree-diff";
    homepage = "https://github.com/JakeWharton/dependency-tree-diff";
    changelog = "https://github.com/JakeWharton/dependency-tree-diff/releases/tag/${finalAttrs.version}";
    sourceProvenance = with lib.sourceTypes; [
      fromSource
      binaryBytecode
    ];
    license = lib.licenses.asl20;
    maintainers = [ lib.maintainers.progrm_jarvis ];
    inherit (jre_headless.meta) platforms;
    badPlatforms = [
      # Currently fails to build on Darwin due to `Could not connect to the Gradle daemon.` error
      lib.systems.inspect.patterns.isDarwin
    ];
  };
})
