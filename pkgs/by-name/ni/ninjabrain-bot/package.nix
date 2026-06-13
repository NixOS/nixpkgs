{
  lib,
  stdenv,
  fetchFromGitHub,
  maven,
  makeWrapper,
  copyDesktopItems,
  makeDesktopItem,
  jre,
  libxkbcommon,
  libx11,
  libxcb,
  libxinerama,
  libxt,
  libxtst,
  nix-update-script,
}:
let
  linuxNativeLibraries = [
    libxkbcommon
    libx11
    libxcb
    libxinerama
    libxt
    libxtst
  ];
in
maven.buildMavenPackage (finalAttrs: {
  pname = "ninjabrain-bot";
  version = "1.5.2";

  src = fetchFromGitHub {
    owner = "Ninjabrain1";
    repo = "Ninjabrain-Bot";
    tag = finalAttrs.version;
    hash = "sha256-uOUPho4UCZxeTtCU4XHJsTR6HuXAnKXd3jk/tSRd4Yc=";
  };
  strictDeps = true;
  __structuredAttrs = true;

  # CI=true skips upstream display-dependent tests; the rest of the suite still runs.
  env.CI = "true";

  mvnFetchExtraArgs = {
    env.CI = "true";
  };

  mvnParameters = "assembly:single";
  mvnHash = "sha256-EZqijVMLPsZJUZA6pLL1Z5HqSeXSFo82XYRIazVweYw=";

  nativeBuildInputs = [
    makeWrapper
    copyDesktopItems
  ];

  installPhase = ''
    runHook preInstall

    install -Dm444 target/ninjabrainbot-${finalAttrs.version}-jar-with-dependencies.jar $out/share/java/ninjabrain-bot.jar

    install -Dm644 src/main/resources/icon.png $out/share/icons/hicolor/640x640/apps/ninjabrain-bot.png

    # Swing text rendering varies outside full desktop environments.
    makeWrapperArgs=(
      --add-flags "-Dawt.useSystemAAFontSettings=on"
      --add-flags "-Dswing.aatext=true"
      --add-flags "-jar $out/share/java/ninjabrain-bot.jar"
    )

    ${lib.optionalString stdenv.hostPlatform.isLinux ''
      makeWrapperArgs+=(
        --prefix LD_LIBRARY_PATH : ${lib.makeLibraryPath linuxNativeLibraries}
      )
    ''}

    makeWrapper ${lib.getExe jre} $out/bin/ninjabrain-bot "''${makeWrapperArgs[@]}"

    runHook postInstall
  '';

  desktopItems = [
    (makeDesktopItem {
      name = "ninjabrain-bot";
      desktopName = "Ninjabrain Bot";
      comment = "Stronghold calculator for Minecraft speedrunning";
      type = "Application";
      exec = "ninjabrain-bot";
      icon = "ninjabrain-bot";
      categories = [
        "Game"
        "Utility"
      ];
      keywords = [
        "minecraft"
        "speedrun"
        "stronghold"
        "mcsr"
      ];
    })
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Stronghold calculator for Minecraft speedrunning";
    homepage = "https://github.com/Ninjabrain1/Ninjabrain-Bot";
    changelog = "https://github.com/Ninjabrain1/Ninjabrain-Bot/releases/tag/${finalAttrs.version}";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [
      nyxar77
      Misaka13514
    ];
    mainProgram = "ninjabrain-bot";
    # Match platforms with bundled JNativeHook libraries and JRE support
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
      "x86_64-darwin"
      "aarch64-darwin"
    ];
  };
})
