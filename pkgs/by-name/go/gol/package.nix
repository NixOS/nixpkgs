{
  lib,
  maven,
  fetchFromGitHub,
  makeWrapper,
  jre,
}:

maven.buildMavenPackage rec {
  pname = "gol";
  version = "0.2.1";

  src = fetchFromGitHub {
    owner = "clarisma";
    repo = "gol-tool";
    tag = version;
    hash = "sha256-jAkBFrtdVsK67n8Oo+/MGPL/JKRsu/6tbqy711exlwo=";
  };

  mvnHash = "sha256-GCyTk/Lmh41qpCeex/qrN7cgPoNCsmmOKeBYllbtTZk";
  mvnParameters = "compile assembly:single -Dmaven.test.skip=true";

  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/{bin,lib}
    cp target/gol-tool-${version}-jar-with-dependencies.jar $out/lib/gol-tool.jar

    makeWrapper ${jre}/bin/java $out/bin/gol \
      --add-flags "-cp $out/lib/gol-tool.jar" \
      --add-flags "com.geodesk.gol.GolTool"

    runHook postInstall
  '';

  meta = with lib; {
    description = "Command-line utility for creating and managing Geographic Object Libraries";
    longDescription = ''
      Use the GOL command-line utility to:
      - build and maintain Geographic Object Libraries (GeoDesk's compact database format for OpenStreetMap features)
      - perform GOQL queries and export the results in a variety of formats.
    '';
    homepage = "https://docs.geodesk.com/gol";
    license = licenses.agpl3Only;
    maintainers = [ maintainers.starsep ];
    platforms = platforms.all;
  };
}
