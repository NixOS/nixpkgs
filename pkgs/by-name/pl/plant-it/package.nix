{
  maven,
  jdk21_headless,
  makeBinaryWrapper,
  lib,
  fetchFromGitHub,
}:
let
  version = "0.10.0";
in
maven.buildMavenPackage {
  pname = "plant-it";
  inherit version;

  src = fetchFromGitHub {
    owner = "MDeLuise";
    repo = "plant-it";
    tag = version;
    hash = "sha256-QnujZecUu7bzllSsrLH6hSZMaWeOUXBrSZ5rbT56pDM=";
  };
  sourceRoot = "source/backend";

  mvnHash = "sha256-3YQOZMXMI6BrHkqud2OKColJWbDXfwnAwRifYxbleqI=";
  nativeBuildInputs = [
    makeBinaryWrapper
  ];

  patches = [ ./Remove-test-needing-internet-connection.patch ];

  installPhase = ''
    runHook preInstall

    install -Dm644 target/plant-it-*.jar $out/share/plant-it/plant-it.jar

    makeBinaryWrapper ${jdk21_headless}/bin/java $out/bin/plant-it --add-flags "-jar $out/share/plant-it/plant-it.jar"

    runHook postInstall
  '';

  meta = {
    changelog = "https://github.com/MDeLuise/plant-it/releases/tag/${version}";
    description = "Self-hosted gardening companion application";
    homepage = "https://plant-it.org";
    maintainers = with lib.maintainers; [ epireyn ];
    license = lib.licenses.gpl3;
    platforms = lib.platforms.unix;
    mainProgram = "plant-it";
  };
}
