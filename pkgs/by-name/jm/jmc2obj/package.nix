{
  lib,
  fetchFromGitHub,
  jre,
  makeWrapper,
  maven,
  nix-update-script,
}:

maven.buildMavenPackage rec {
  pname = "j-mc-2-obj";
  version = "128";

  src = fetchFromGitHub {
    owner = "jmc2obj";
    repo = "j-mc-2-obj";
    tag = version;
    hash = "sha256-3+vH1pGJ6I4oobb2vk+J5GrOQrSLNoCuBIC9OsWYCj0=";
  };

  mvnHash = "sha256-ZU/5RGujCdmlBuxtHDaBpF/54e8W/Kca+2jtTudMXWo=";

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

  passthru.updateScript = nix-update-script { };

  meta = {
    changelog = "https://github.com/jmc2obj/j-mc-2-obj/releases/tag/${version}";
    description = "Java-based Minecraft-to-OBJ exporter";
    homepage = "https://github.com/jmc2obj/j-mc-2-obj";
    license = lib.licenses.gpl2Only;
    maintainers = with lib.maintainers; [ eymeric ];
    mainProgram = "jMc2Obj";
  };
}
