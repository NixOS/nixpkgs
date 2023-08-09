{ lib, fetchFromGitHub, makeDesktopItem, copyDesktopItems, makeWrapper
, jre, maven
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
  mvnParameters = "-Pno-git-rev -Dgit.commit.id.describe=${version} -Dproject.build.outputTimestamp=${buildDate} -DbuildTimestamp=${buildDate}";
in
maven.buildMavenPackage rec {
  pname = "digital";
  inherit version jre;

  src = fetchFromGitHub {
    owner = "hneemann";
    repo = "Digital";
    rev = "v${version}";
    hash = "sha256-cDykYlcFvDLFBy9UnX07iCR2LCq28SNU+h9vRT/AoJM=";
  };

  inherit mvnParameters;
  mvnHash = "sha256-wm/axWJucoW9P98dKqHI4bjrUnmBTfosCOdJg9VBJ+4=";

  nativeBuildInputs = [ copyDesktopItems makeWrapper ];

  installPhase = ''
    mkdir -p $out/bin
    mkdir -p $out/share/java

    classpath=$(find $mvnDeps/.m2 -name "*.jar" -printf ':%h/%f');
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
