{
  lib,
  maven,
  fetchFromGitHub,
  jdk21,
  makeWrapper,
  nix-update-script,
}:

let
  jdk = jdk21;
in

maven.buildMavenPackage rec {
  pname = "ohsome-planet";
  version = "1.1.0";

  src = fetchFromGitHub {
    owner = "GIScience";
    repo = pname;
    tag = "${version}";
    sha256 = "sha256-DFrjYlCwS96wBBiB4Fm9ZfFhgbqSiCfCwCkYfeY105g=";
  };

  # FIXME: I didn't realize how to get the hash for maven
  mvnHash = null;

  # Skip tests during build to avoid test failures
  mvnParameters = "-DskipTests";

  passthru.updateScript = nix-update-script { };

  mvnBuildTarget = "ohsome-planet-cli";

  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    runHook preInstall

    install -D ohsome-planet-cli/target/ohsome-planet.jar --target-directory=$out/lib

    makeWrapper ${lib.getExe' jdk "java"} $out/bin/ohsome-planet \
      --add-flags "-jar $out/lib/ohsome-planet.jar"
  '';

  meta = {
    description = "Tool to transform OSM (history) PBF files into GeoParquet";
    homepage = "https://github.com/GIScience/ohsome-planet";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ onnimonni ];
  };
}
