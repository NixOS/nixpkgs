{
  makeWrapper,
  gradle_9,
  zenity,
  temurin-jre-bin-25,
  makeDesktopItem,
  jdk25,
  copyDesktopItems,
  runCommand,
  stdenv,
  fetchFromGitHub,
  lib,
  nix-update-script,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "cogfly";
  version = "1.2.5";

  src = fetchFromGitHub {
    owner = "Nix-main";
    repo = "Cogfly";
    tag = finalAttrs.version;
    hash = "sha256-noOe0Jyb53swzloY7e1TWI6oYzOpQclrTU38/R5mvXk=";
  };

  patches = [ ./fix-macos-open-saves.patch ];

  nativeBuildInputs = [
    gradle_9
    makeWrapper
    copyDesktopItems
  ];

  buildInputs = lib.optionals stdenv.hostPlatform.isLinux [
    zenity
  ];

  desktopItems = [
    (makeDesktopItem {
      name = "Cogfly";
      desktopName = "Cogfly";
      exec = "cogfly";
      icon = "cogfly";
      type = "Application";
      categories = [
        "Utility"
      ];
      mimeTypes = [
        "x-scheme-handler/cogfly"
      ];
    })
  ];

  mitmCache = gradle_9.fetchDeps {
    pkg = finalAttrs.finalPackage;
    data = ./deps.json;
  };

  strictDeps = true;
  __structuredAttrs = true;

  gradleFlags = [
    "-Dorg.gradle.java.home=${jdk25}"
  ];

  gradleBuildTask = "shadowJar";

  doCheck = true;

  installPhase = ''
    mkdir -p $out/bin
    cp build/libs/${lib.strings.toSentenceCase finalAttrs.pname}-${finalAttrs.version}.jar $out/bin

    makeWrapper ${lib.getExe temurin-jre-bin-25} $out/bin/cogfly \
      --add-flags "-Xdock:name=Cogfly" \
      --add-flags "-Xdock:icon=$out/share/icons/hicolor/128x128/apps/cogfly.png" \
      --add-flags "-jar $out/bin/${lib.strings.toSentenceCase finalAttrs.pname}-${finalAttrs.version}.jar" \
      --prefix PATH : "${lib.makeBinPath (lib.optionals stdenv.hostPlatform.isLinux [ zenity ])}"

    copyDesktopItems

    install -m 444 -D resources/icons/icon.png $out/share/icons/cogfly
    install -m 444 -D resources/icons/icon.png $out/share/icons/hicolor/128x128/apps/cogfly.png
  ''
  + (lib.optionalString stdenv.hostPlatform.isDarwin ''
    mkdir -p \
      $out/Applications/Cogfly.app/Contents/MacOS \
      $out/Applications/Cogfly.app/Contents/Resources
    cp $out/bin/cogfly $out/Applications/Cogfly.app/Contents/MacOS/cogfly
    cp resources/mac/Info.plist $out/Applications/Cogfly.app/Contents/Info.plist
    cp resources/icons/icon.icns $out/Applications/Cogfly.app/Contents/Resources/Cogfly.icns
  '');

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Cross-platform mod manager for Hollow Knight: Silksong";
    homepage = "https://github.com/Nix-main/Cogfly";
    changelog = "https://github.com/Nix-main/Cogfly/releases/tag/${finalAttrs.version}";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [
      abus-sh
    ];
    mainProgram = "cogfly";
    platforms = [
      "x86_64-linux"
      "aarch64-darwin"
    ];
  };
})
