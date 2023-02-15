{ lib, stdenv, fetchFromGitHub, makeDesktopItem, copyDesktopItems, makeWrapper
, jre, maven, git
}:

let
  pkgDescription = "A digital logic designer and circuit simulator.";
  version = "0.30";
  buildDate = "2023-02-03T08:00:56+01:00"; # v0.30 commit date

  desktopItem = makeDesktopItem {
    type = "Application";
    name = "Digital";
    desktopName = pkgDescription;
    comment = "Easy-to-use digital logic designer and circuit simulator";
    exec = "digital";
    icon = "digital";
    categories = [ "Education" "Electronics" ];
    mimeTypes = [ "text/x-digital" ];
    terminal = false;
    keywords = [ "simulator" "digital" "circuits" ];
  };

  # Use the "no-git-rev" maven profile, which deactivates the plugin that
  # inspect the .git folder to find the version number we are building, we then
  # provide that version number manually as a property.
  # (see https://github.com/hneemann/Digital/issues/289#issuecomment-513721481)
  # Also use the commit date as a build and output timestamp.
  mvnOptions = "-Pno-git-rev -Dgit.commit.id.describe=${version} -Dproject.build.outputTimestamp=${buildDate} -DbuildTimestamp=${buildDate}";
in
stdenv.mkDerivation rec {
  pname = "digital";
  inherit version jre;

  src = fetchFromGitHub {
    owner = "hneemann";
    repo = "Digital";
    rev = "932791eb6486d04f2ea938d83bcdb71b56d3a3f6";
    sha256 = "cDykYlcFvDLFBy9UnX07iCR2LCq28SNU+h9vRT/AoJM=";
  };

  # Fetching maven dependencies from "central" needs the network at build phase,
  # we do that in this extra derivation that explicitely specifies its
  # outputHash to ensure determinism.
  mavenDeps = stdenv.mkDerivation {
    name = "${pname}-${version}-maven-deps";
    inherit src nativeBuildInputs version;
    dontFixup = true;
    buildPhase = ''
      mvn package ${mvnOptions} -Dmaven.repo.local=$out
    '';
    # keep only *.{pom,jar,sha1,nbm} and delete all ephemeral files with
    # lastModified timestamps inside
    installPhase = ''
      find $out -type f \
        -name \*.lastUpdated -or \
        -name resolver-status.properties -or \
        -name _remote.repositories \
        -delete
    '';
    outputHashAlgo = "sha256";
    outputHashMode = "recursive";
    outputHash = "1Cgw+5V2E/RENMRMm368+2yvY7y6v9gTlo+LRgrCXcE=";
  };

  nativeBuildInputs = [ copyDesktopItems maven makeWrapper ];

  buildPhase = ''
    mvn package --offline ${mvnOptions} -Dmaven.repo.local=${mavenDeps}
  '';

  installPhase = ''
    mkdir -p $out/bin
    mkdir -p $out/share/java

    classpath=$(find ${mavenDeps} -name "*.jar" -printf ':%h/%f');
    install -Dm644 target/Digital.jar $out/share/java

    makeWrapper ${jre}/bin/java $out/bin/${pname} \
      --add-flags "-classpath $out/share/java/${pname}-${version}.jar:''${classpath#:}" \
      --add-flags "-jar $out/share/java/Digital.jar"
  '';

  desktopItems = [ desktopItem ];

  meta = with lib; {
    homepage = "https://github.com/hneemann/Digital";
    description = pkgDescription;
    license = licenses.gpl3Only;
    platforms = [ "x86_64-linux" "x86_64-darwin" ];
    maintainers = with maintainers; [ Dettorer ];
  };
}
