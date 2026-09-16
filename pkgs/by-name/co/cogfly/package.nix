{
  makeWrapper,
  runCommand,
  stdenv,
  fetchFromGitHub,
  pkgs,
  lib,
  nix-update-script,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "cogfly";
  version = "1.2.5";

  src = fetchFromGitHub {
    owner = "Nix-main";
    repo = "Cogfly";
    tag = "${finalAttrs.version}";
    hash = "sha256-noOe0Jyb53swzloY7e1TWI6oYzOpQclrTU38/R5mvXk=";
  };

  nativeBuildInputs = with pkgs; [
    gradle_9
    makeWrapper
  ];

  buildInputs = with pkgs; [
    zenity
  ];

  desktopItem = pkgs.makeDesktopItem {
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
  };

  mitmCache = pkgs.gradle.fetchDeps {
    pkg = finalAttrs.finalPackage;
    data = ./deps.json;
  };

  strictDeps = true;
  __structuredAttrs = true;
  __darwinAllowLocalNetworking = true;

  gradleFlags = [
    "-Dorg.gradle.java.home=${pkgs.jdk25}"
  ];

  gradleBuildTask = "shadowJar";

  doCheck = true;

  installPhase = ''
    mkdir -p $out/bin
    cp build/libs/${finalAttrs.pname}-${finalAttrs.version}.jar $out/bin

    makeWrapper ${lib.getExe pkgs.temurin-jre-bin-25} $out/bin/cogfly \
      --add-flags "-jar $out/bin/${finalAttrs.pname}-${finalAttrs.version}.jar" \
      --prefix PATH : ${lib.makeBinPath [ pkgs.zenity ]}

    install -m 644 -D -t $out/share/applications $desktopItem/share/applications/*

    install -m 444 -D resources/icons/icon.png $out/share/icons/cogfly
    install -m 444 -D resources/icons/icon.png $out/share/icons/hicolor/128x128/apps/cogfly.png
  '';

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
    ];
  };
})
