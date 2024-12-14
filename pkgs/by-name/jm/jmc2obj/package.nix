{
  lib,
  fetchFromGitHub,
  jre,
  makeWrapper,
  maven,
}:

maven.buildMavenPackage rec {
  pname = "j-mc-2-obj";
  version = "126";

  src = fetchFromGitHub {
    owner = "jmc2obj";
    repo = pname;
    rev = version;
    hash = "sha256-c0qLryv9Gx9BlKXmwSKkK5/v3Wypny841htNfsNNxpg=";
  };

  mvnHash = "sha256-ya8E/6tOxyW+AO7v9p0dg72qFpQjWwvntZOw+TEKq0k=";

  mvnParameters = "-Dmaven.gitcommitid.skip=true";

  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    runHook preInstall
    mkdir -p $out/bin $out/share/jMc2Obj
    install -Dm644 JAR/jMc2Obj-${version}.jar $out/share/jMc2Obj

    makeWrapper ${lib.getExe jre} $out/bin/jMc2Obj \
      --add-flags "-jar $out/share/jMc2Obj/jMc2Obj-${version}.jar"
    runHook postInstall
  '';

  meta = {
    changelog = "https://github.com/jmc2obj/j-mc-2-obj/releases/tag/${version}";
    description = "Java-based Minecraft-to-OBJ exporter";
    homepage = "https://github.com/jmc2obj/j-mc-2-obj";
    license = lib.licenses.gpl2Only;
    maintainers = with lib.maintainers; [ eymeric ];
    mainProgram = "jMc2Obj";
  };
}
