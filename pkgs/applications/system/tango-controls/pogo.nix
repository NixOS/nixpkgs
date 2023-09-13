{ fetchFromGitLab
, lib
, makeWrapper
, jre
, jdk11
, maven
}:
let
  mavenJdk11 = maven.override { jdk = jdk11; };
in
mavenJdk11.buildMavenPackage rec {
  pname = "pogo";
  version = "9.8.3";

  src = fetchFromGitLab {
    owner = "tango-controls";
    repo = pname;
    rev = version;
    hash = "sha256-e2uZgq57Xf9b2i0ZBkijoMWjSGtmgJ+nz8NVT1qMQE4=";
  };

  postUnpack = ''
    rm -r source/org.tango.pogo.pogo_gui/src/existingcode
  '';

  # Passing "-f fr.esrf.tango.pogo.parent/pom.xml" to "mvnParameters" is not enough - you have to "cd"
  preBuild = ''
    cd fr.esrf.tango.pogo.parent
  '';

  mvnFetchExtraArgs = {
    buildPhase = ''
      rm -r org.tango.pogo.pogo_gui/src/existingcode
      cd fr.esrf.tango.pogo.parent
      mvn package -Dmaven.repo.local=$out/.m2
    '';
  };

  mvnHash = "sha256-TspWKitRfbrg6vRd6pmRAkbF0m7PqHSvcrT+wwyLzvg=";

  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    runHook preInstall
    echo "========================================="
    find .. -name '*.jar'
    echo "========================================="
    mkdir -p $out/bin $out/share/pogo
    install -Dm644 ../org.tango.pogo.pogo_gui/target/Pogo-${version}-SNAPSHOT.jar $out/share/pogo/pogo.jar

    makeWrapper ${jre}/bin/java $out/bin/pogo --add-flags "-jar $out/share/pogo/pogo.jar"
    runHook postInstall
  '';

  meta = with lib; {
    description = "Administration tool for the Tango controls system";
    homepage = "https://www.tango-controls.org";
    changelog = "https://gitlab.com/tango-controls/cppTango/-/blob/${version}/RELEASE_NOTES.md";
    downloadPage = "https://gitlab.com/tango-controls/TangoSourceDistribution/-/releases";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ pmiddend ];
    platforms = platforms.unix;
  };

}
