{
  copyDesktopItems,
  fetchFromGitHub,
  jre ? pkgs.jre,
  lib,
  makeDesktopItem,
  makeWrapper,
  maven,
  pkgs,
}:
maven.buildMavenPackage rec {
  pname = "ninjabrain-bot";
  version = "1.5.1";

  src = fetchFromGitHub {
    owner = "Ninjabrain1";
    repo = "Ninjabrain-Bot";
    tag = version;
    hash = "sha256-r8TpL3VLf2QHwFS+DdjxgxyuZu167fP6/lN7a8e9opM=";
  };

  doCheck = false;

  mvnParameters = "assembly:single";
  mvnHash = "sha256-zAVPH5a7ut21Ipz5BUY6cnRLT52bM8Yo2r8ClFon1p0=";

  nativeBuildInputs = [
    copyDesktopItems
    makeWrapper
  ];

  linkedLibraries = with pkgs; [
    libxkbcommon
    xorg.libX11
    xorg.libXt
  ];

  installPhase = ''
    runHook preInstall

    install -m444 -D target/ninjabrainbot-${version}-jar-with-dependencies.jar $out/share/java/ninjabrain-bot.jar
    makeWrapper ${lib.getExe jre} $out/bin/ninjabrain-bot \
      --add-flags "-jar $out/share/java/ninjabrain-bot.jar" \
      --prefix LD_LIBRARY_PATH ":" ${lib.makeLibraryPath linkedLibraries}

    runHook postInstall
  '';

  desktopItems = [
    (makeDesktopItem {
      name = "ninjabrain-bot";
      type = "Application";
      exec = "ninjabrain-bot";
      comment = "Accurate stronghold calculator for Minecraft speedrunning";
      desktopName = "Ninjabrain Bot";
    })
  ];
  passthru.updateScript = ./update.sh;

  meta = {
    description = "Accurate stronghold calculator for Minecraft speedrunning";
    homepage = "https://github.com/Ninjabrain1/Ninjabrain-Bot";
    changelog = "https://github.com/Ninjabrain1/Ninjabrain-Bot/releases/tag/${version}";
    license = lib.licenses.unfree;
    maintainers = with lib.maintainers; [ emilio-barradas ];
  };
}
