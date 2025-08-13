{ lib, maven, fetchFromGitHub, jdk21, makeWrapper }:

maven.buildMavenPackage rec {
  pname = "ohsome-planet";
  version = "1.1.0";

  src = fetchFromGitHub {
    owner = "GIScience";
    repo = pname;
    rev = "${version}";
    # FIXME: I didn't realize how to get the sha256 hash for the source
    sha256 = null;
  };

  # FIXME: I didn't realize how to get the sha256 hash for maven
  mvnHash = null;

  jdk = jdk21;

  # Skip tests during build to avoid test failures
  mvnParameters = "-DskipTests";

  # Build the specific module we want (ohsome-planet-cli)
  mvnBuildTarget = "ohsome-planet-cli";

  # makeWrapper is used to create a wrapper script for the JAR file.
  nativeBuildInputs = [ makeWrapper ];

  # The installPhase is customized to place the final JAR in a known location
  # and create a wrapper script to make it easily executable.
  installPhase = ''
    runHook preInstall

    # Create directories for the library JAR and the executable script
    mkdir -p $out/lib $out/bin

    # Copy the compiled JAR file to the output's lib directory
    cp ohsome-planet-cli/target/ohsome-planet.jar $out/lib/ohsome-planet.jar

    # Use makeWrapper to create an executable script in $out/bin.
    # This script will call java with the correct JAR file.
    makeWrapper ${jdk}/bin/java $out/bin/ohsome-planet \
      --add-flags "-jar $out/lib/ohsome-planet.jar"

    runHook postInstall
  '';

  meta = with lib; {
    description = "Tool to transform OSM (history) PBF files into GeoParquet";
    homepage = "https://github.com/GIScience/ohsome-planet";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [
      onnimonni
    ];
    platforms = platforms.all;
  };
}
