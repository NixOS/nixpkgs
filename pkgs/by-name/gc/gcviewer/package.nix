{ lib, fetchFromGitHub, git, maven, makeWrapper, temurin-jre-bin-17 }:
let
  jre = temurin-jre-bin-17;
in
maven.buildMavenPackage {
  pname = "GCViewer";
  version = "1.37-unreleased";
  src = fetchFromGitHub {
    owner = "chewiebug";
    repo = "GCViewer";
    rev = "af97692884ac918ccbdf7a123fa698460a1d397e";
    hash = "sha256-o4TPerkcu1Um701IHqqRQr/eCjm+WUCbI0uZBlhCBis=";
  }
;
  buildOffline = true;

  mvnFetchExtraArgs = { buildInputs = [git]; };

  mvnParameters = "-Dmaven.test.skip=true";

  nativeBuildInputs = [ git makeWrapper ];

  installPhase = ''
    mkdir -p $out/bin $out/share
    jarfile=$(cd target && echo *.jar)
    install -Dm644 "target/$jarfile" $out/share/
    makeWrapper ${jre}/bin/java $out/bin/gcviewer \
      --add-flags "-jar $out/share/$jarfile"
  '';

  mvnHash = "sha256-EpnpPNbTVFp2+iaisFG9VNkbMf5DuylO+YM2RIWfB8A=";

  meta = with lib; {
    description = "Analyse Java garbage collection log files";
    homepage = "https://github.com/chewiebug/GCViewer";
    license = licenses.lgpl2;
    maintainers = teams.deshaw.members;
    mainProgram = "gcviewer";
  };
}

