{ lib, maven, fetchFromGitHub, makeWrapper, jre }:

maven.buildMavenPackage rec {
  pname = "gol";
  version = "0.2.0";

  src = fetchFromGitHub {
    owner = "clarisma";
    repo = "gol-tool";
    rev = version;
    hash = "sha256-F/tMRD+nWn/fRPX7cTan371zlOTxh7oR98wREmokULo=";
  };

  mvnHash = "sha256-b0nkp23gv4kejac/xrvm3xWo3Z8if7zveNUHBg7ZBm4=";
  mvnParameters = "compile assembly:single -Dmaven.test.skip=true";

  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/{bin,lib}
    cp /build/source/target/gol-tool-${version}-jar-with-dependencies.jar $out/lib/gol-tool.jar

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
