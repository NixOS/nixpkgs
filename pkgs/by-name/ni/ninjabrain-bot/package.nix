{
  copyDesktopItems,
  fetchFromGitHub,
  jre,
  lib,
  libxkbcommon,
  makeDesktopItem,
  makeWrapper,
  maven,
  nix-update-script,
  xorg,
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

  patches = [
    ./fix-allAdvancements-test-travelAngle-values.patch
  ];

  # Skip GUI tests that require a display
  env.CI = "true";

  mvnParameters = "assembly:single";
  mvnHash = "sha256-VIEYl4lUTZDsXMnSrXIOG6WiYhZguPRq9bCJhfrVfJI=";

  nativeBuildInputs = [
    copyDesktopItems
    makeWrapper
  ];

  linkedLibraries = [
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

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Accurate stronghold calculator for Minecraft speedrunning";
    homepage = "https://github.com/Ninjabrain1/Ninjabrain-Bot";
    changelog = "https://github.com/Ninjabrain1/Ninjabrain-Bot/releases/tag/${version}";
    license = lib.licenses.unfree;
    maintainers = with lib.maintainers; [ emilio-barradas ];
  };
}
