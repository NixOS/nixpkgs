{
  lib,
  stdenv,
  fetchFromGitHub,
  makeBinaryWrapper,
  makeDesktopItem,
  jdk,
  gradle,
  copyDesktopItems,
  jre,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "freerouting";
  version = "2.1.0";

  src = fetchFromGitHub {
    owner = "freerouting";
    repo = "freerouting";
    tag = "v${finalAttrs.version}";
    hash = "sha256-K4fwbvSPuKAAnIcTDBSAI1/6HuCB7c9rCGTJcyAj5dQ=";
  };

  gradleBuildTask = "executableJar";

  nativeBuildInputs = [
    makeBinaryWrapper
    jdk
    gradle
    copyDesktopItems
  ];

  mitmCache = gradle.fetchDeps {
    inherit (finalAttrs) pname;
    data = ./deps.json;
  };

  __darwinAllowLocalNetworking = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/{bin,share/freerouting}
    cp build/libs/freerouting-executable.jar $out/share/freerouting

    makeWrapper ${lib.getExe jre} $out/bin/freerouting \
      --add-flags "-jar $out/share/freerouting/freerouting-executable.jar"

    install -Dm644 ${finalAttrs.src}/design/icon/freerouting_icon_256x256_v1.png \
      $out/share/icons/hicolor/256x256/apps/freerouting.png

    runHook postInstall
  '';

  desktopItems = [
    (makeDesktopItem {
      name = finalAttrs.pname;
      exec = "freerouting";
      icon = "freerouting";
      desktopName = "Freerouting";
      comment = finalAttrs.meta.description;
      categories = [
        "Electricity"
        "Engineering"
        "Graphics"
      ];
    })
  ];

  meta = {
    description = "Advanced PCB auto-router";
    homepage = "https://www.freerouting.org";
    changelog = "https://github.com/freerouting/freerouting/releases/tag/v${finalAttrs.version}";
    longDescription = ''
      Freerouting is an advanced autorouter for all PCB programs that support
      the standard Specctra or Electra DSN interface. '';
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ srounce ];
    platforms = with lib.platforms; linux ++ darwin;
    mainProgram = "freerouting";
  };
})
