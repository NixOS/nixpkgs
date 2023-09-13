{ fetchFromGitLab
, lib
, makeWrapper
, jre
, maven
}:
maven.buildMavenPackage rec {
  pname = "jive";
  version = "7.36";

  src = fetchFromGitLab {
    owner = "tango-controls";
    repo = pname;
    rev = version;
    hash = "sha256-TyCCD//b71XI28O3R0WFeRXu4H5/e0H+WF8MI3Yvvnc=";
  };

  mvnHash = "sha256-qKUTqT9r9gW+WIAjEldGRg9i/FqTxIkMnt2si9RW+nc=";

  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    mkdir -p $out/bin $out/share/jive
    install -Dm644 target/Jive-${version}-jar-with-dependencies.jar $out/share/jive/jive.jar

    makeWrapper ${jre}/bin/java $out/bin/jive --add-flags "-jar $out/share/jive/jive.jar"
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
