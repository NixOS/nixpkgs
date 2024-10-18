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
  version = "1.4.3";

  src = fetchFromGitHub {
    owner = "Ninjabrain1";
    repo = "Ninjabrain-Bot";
    rev = version;
    hash = "sha256-d2vfAPUMXwqwSLL76WwWd//JxUKmBGW2b+BHrpCREig=";
  };

  doCheck = false;

  mvnParameters = "assembly:single";
  mvnHash = "sha256-GFMBUvJSvcfC8OwpjJ0Ee9Z/IrvObcWl6RJqs2NcKhQ=";

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
    makeWrapper ${jre}/bin/java $out/bin/ninjabrain-bot \
      --add-flags "-jar $out/share/java/ninjabrain-bot.jar" \
      --prefix LD_LIBRARY_PATH ":" ${lib.makeLibraryPath linkedLibraries}

    runHook postInstall
  '';

  desktopItems = [
    (makeDesktopItem {
      name = "ninjabrain-bot";
      type = "Application";
      exec = "ninjabrain-bot";
      comment = "Accurate stronghold calculator for Minecraft speedrunning.";
      desktopName = "Ninjabrain Bot";
    })
  ];

  meta = {
    description = "Accurate stronghold calculator for Minecraft speedrunning.";
    homepage = "https://github.com/Ninjabrain1/Ninjabrain-Bot";
    maintainers = with lib.maintainers; [ emilio-barradas ];
  };
}
