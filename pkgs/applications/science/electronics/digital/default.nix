{ lib, stdenv, fetchFromGitHub, makeDesktopItem, copyDesktopItems, makeWrapper
, jre, maven, git
}:

let
  pkgDescription = "A digital logic designer and circuit simulator.";
  version = "0.29";
  buildDate = "2022-02-11T18:10:34+01:00"; # v0.29 commit date

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
  mvnOptions = "-Pno-git-rev -Dgit.commit.id.describe=${version} -Dproject.build.outputTimestamp=${buildDate}";
in
stdenv.mkDerivation rec {
  pname = "digital";
  inherit version jre;

  src = fetchFromGitHub {
    owner = "hneemann";
    repo = "Digital";
    rev = "287dd939d6f2d4d02c0d883c6178c3425c28d39c";
    sha256 = "o5gaExUTTbk6WgQVw7/IeXhpNkj1BLkwD752snQqjIg=";
  };

  # Use fixed dates in the pom.xml and upgrade the jar and assembly plugins to
  # a version where they support reproducible builds
  patches = [ ./pom.xml.patch ];

  # Fetching maven dependencies from "central" needs the network at build phase,
  # we do that in this extra derivation that explicitely specifies its
  # outputHash to ensure determinism.
  mavenDeps = stdenv.mkDerivation {
    name = "${pname}-${version}-maven-deps";
    inherit src nativeBuildInputs version patches postPatch;
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
    outputHash = "X5ppGUVwNQrMnjzD4Kin1Xmt4O3x+qr7jK4jr6E8tCI=";
  };

  nativeBuildInputs = [ copyDesktopItems maven makeWrapper ];

  postPatch = ''
    substituteInPlace pom.xml --subst-var-by buildDate "${buildDate}"
  '';

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
