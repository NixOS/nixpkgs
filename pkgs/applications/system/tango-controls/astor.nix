{ fetchFromGitLab
, lib
, makeWrapper
, jre
, maven
}:
maven.buildMavenPackage rec {
  pname = "astor";
  # tango 9.4.2 bundles astor version 7.4.4, but this doesn't install
  # properly ("mainClass" attribute missing), so we take a newer one
  version = "7.5.3";

  src = fetchFromGitLab {
    owner = "tango-controls";
    repo = pname;
    rev = version;
    hash = "sha256-XqZMIYtpGv9jpS3l1OD1BPzeeH+RDZImfzemrktRRrQ=";
  };

  mvnHash = "sha256-3ahyxk5UbTCkb8e+P1PS2uwDzt1f8HbdzAT2wjFL7OA=";

  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    mkdir -p $out/bin $out/share/astor
    install -Dm644 target/Astor-${version}-jar-with-dependencies.jar $out/share/astor/astor.jar

    makeWrapper ${jre}/bin/java $out/bin/astor --add-flags "-jar $out/share/astor/astor.jar"
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
