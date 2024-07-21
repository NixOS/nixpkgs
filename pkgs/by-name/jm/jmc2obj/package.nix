{
  lib,
  fetchFromGitHub,
  jre,
  makeWrapper,
  maven,
}:

maven.buildMavenPackage rec {
  pname = "j-mc-2-obj";
  version = "125";

  src = fetchFromGitHub {
    owner = "jmc2obj";
    repo = pname;
    rev = version;
    hash = "sha256-HVY99dWQ8hHMzY5okABa+MW4+L4OYhsTBmScO6hjJC0=";
  };

  mvnHash = "sha256-UGKDrrfoVnHe8rHOm1/NU38vNkSIpQbEnkF3yQVdGqM=";

  mvnParameters = "-Dmaven.gitcommitid.skip=true";

  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    mkdir -p $out/bin $out/share/jMc2Obj
    install -Dm644 JAR/jMc2Obj-${version}.jar $out/share/jMc2Obj

    makeWrapper ${jre}/bin/java $out/bin/jMc2Obj \
      --add-flags "-jar $out/share/jMc2Obj/jMc2Obj-${version}.jar"
  '';

  meta = {
    description = "Java-based Minecraft-to-OBJ exporter";
    homepage = "https://github.com/jmc2obj/j-mc-2-obj";
    # license = ; # this project has still no license
    maintainers = with lib.maintainers; [ eymeric ];
  };
}
