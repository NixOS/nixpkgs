{
  fetchFromGitHub,
  gradle,
  jdk_headless,
  lib,
  makeBinaryWrapper,
  stdenvNoCC,
}:
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "souffle-lsp-plugin";
  version = "0.3.8";

  src = fetchFromGitHub {
    owner = "jdaridis";
    repo = "souffle-lsp-plugin";
    tag = "v${finalAttrs.version}";
    hash = "sha256-tMdSGPr1IBXHT4U8HRE6WeZz8y3tPYyg26RAtrL/Nuo=";
  };

  nativeBuildInputs = [
    gradle
    makeBinaryWrapper
  ];

  mitmCache = gradle.fetchDeps {
    inherit (finalAttrs) pname;
    data = ./deps.json;
  };

  preBuild = ''
    rm -rf build # Remove prebuilt jar
  '';

  installPhase = ''
    runHook preInstall

    install -Dm644  build/libs/Souffle_Ide_Plugin-1.0-SNAPSHOT.jar \
      --target-directory="$out"/share/java

    # Execute the lsp with a wrapped java
    makeWrapper ${lib.getExe' jdk_headless "java"} "$out"/bin/souffle-lsp \
      --add-flags "-jar $out/share/java/Souffle_Ide_Plugin-1.0-SNAPSHOT.jar" \
      --set JAVA_HOME "${jdk_headless}/lib/openjdk"

    runHook postInstall
  '';

  meta = {
    description = "Soufflé Datalog Language Server";
    homepage = "https://github.com/jdaridis/souffle-lsp-plugin";
    changelog = "https://github.com/jdaridis/souffle-lsp-plugin/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    license = lib.licenses.unfree;
    inherit (jdk_headless.meta) platforms;
    maintainers = with lib.maintainers; [ tbaldwin ];
    mainProgram = "souffle-lsp";
  };
})
