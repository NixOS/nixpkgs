{
  maven,
  jdk21_headless,
  makeBinaryWrapper,
  lib,
  callPackage,
  fetchFromGitHub,
  nix-update-script,
  plant-it-frontend,
}:
let
  version = "0.10.0";
  src = fetchFromGitHub {
    owner = "MDeLuise";
    repo = "plant-it";
    tag = version;
    hash = "sha256-QnujZecUu7bzllSsrLH6hSZMaWeOUXBrSZ5rbT56pDM=";
  };
  backend-src = "${src}/backend";
in
maven.buildMavenPackage {
  pname = "plant-it";
  inherit version;
  src = backend-src;

  mvnHash = "sha256-pj4RJrzHeGIO8cpMl1AqS3A0B4MPbOMFrQiPLFG/FtA=";
  nativeBuildInputs = [
    makeBinaryWrapper
  ];

  installPhase = ''
    runHook preInstall

    install -Dm644 target/plant-it-*.jar $out/share/plant-it/plant-it.jar

    makeBinaryWrapper ${jdk21_headless}/bin/java $out/bin/plant-it --add-flags "-jar $out/share/plant-it/plant-it.jar"

    runHook postInstall
  '';

  doCheck = false; # An integration test requires an Internet access, and therefore breaks sandbox mode

  passthru = {
    root-src = src; # To build frontend
    updateScript = nix-update-script { };
  };

  meta = with lib; {
    changelog = "https://github.com/MDeLuise/plant-it/releases/tag/${version}";
    description = "Self-hosted gardening companion application";
    homepage = "https://plant-it.org";
    maintainers = with maintainers; [ epireyn ];
    license = licenses.gpl3;
    platforms = platforms.unix;
    mainProgram = "plant-it";
  };
}
