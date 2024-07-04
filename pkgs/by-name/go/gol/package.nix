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

<<<<<<< HEAD
<<<<<<< HEAD
  mvnHash = "sha256-6EX+y7/lGdB5LgW9MIER+KgvtPjvMCDjgq89f1g2GlY=";
=======
  mvnHash = "sha256-b0nkp23gv4kejac/xrvm3xWo3Z8if7zveNUHBg7ZBm4=";
>>>>>>> 8cb786adbe12 (Merge pull request #324598 from r-ryantm/auto-update/ldc)
=======
  mvnHash = "sha256-b0nkp23gv4kejac/xrvm3xWo3Z8if7zveNUHBg7ZBm4=";
=======
  mvnHash = "sha256-6EX+y7/lGdB5LgW9MIER+KgvtPjvMCDjgq89f1g2GlY=";
>>>>>>> 528945994acf (Merge pull request #323329 from iivusly/halloy-darwin)
>>>>>>> c7fabb43cb21 (Merge pull request #323329 from iivusly/halloy-darwin)
  mvnParameters = "compile assembly:single -Dmaven.test.skip=true";

  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/{bin,lib}
<<<<<<< HEAD
<<<<<<< HEAD
    cp target/gol-tool-${version}-jar-with-dependencies.jar $out/lib/gol-tool.jar
=======
    cp /build/source/target/gol-tool-${version}-jar-with-dependencies.jar $out/lib/gol-tool.jar
>>>>>>> 8cb786adbe12 (Merge pull request #324598 from r-ryantm/auto-update/ldc)
=======
    cp /build/source/target/gol-tool-${version}-jar-with-dependencies.jar $out/lib/gol-tool.jar
=======
    cp target/gol-tool-${version}-jar-with-dependencies.jar $out/lib/gol-tool.jar
>>>>>>> 528945994acf (Merge pull request #323329 from iivusly/halloy-darwin)
>>>>>>> c7fabb43cb21 (Merge pull request #323329 from iivusly/halloy-darwin)

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
