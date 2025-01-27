{
  fetchFromGitHub,
  maven,
  makeWrapper,
  jre,
  lib,
}:

maven.buildMavenPackage rec {
  pname = "joularjx";
  version = "2.9.0";

  src = fetchFromGitHub {
    owner = "joular";
    repo = pname;
    rev = version;
    hash = "sha256-/Drv6PVMmz3QNEu8zMokTKBZeYWMjuKczu18qKqNAx4=";
  };

  mvnHash = "sha256-TKHo0hZBjgBeUWYvbjF3MZ6Egp3qB2LGwWfrGrcVkOk=";

  mvnParameters = "-DskipTests";

  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    runHook preInstall
    mkdir -p $out/share
    cp target/joularjx-${version}.jar $out/share/joularjx.jar
    makeWrapper ${jre}/bin/java $out/bin/joularjx \
      --add-flags "-javaagent:$out/share/joularjx.jar"
    runHook postInstall
  '';

  meta = with lib; {
    description = "Java-based agent for software power monitoring at the source code level";
    homepage = "https://github.com/joular/joularjx";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ julienmalka ];
    platforms = platforms.linux;
  };
}
