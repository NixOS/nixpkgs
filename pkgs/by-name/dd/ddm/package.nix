{
  stdenvNoCC,
  lib,
  requireFile,
  copyDesktopItems,
  electron,
  makeDesktopItem,
  makeWrapper,
  unzip,

  campaigns ? [ ],
  cubes ? [ ],
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "ddm";
  version = "3.0.2";

  src = requireFile {
    name = "DungeonDuelMonsters-linux-x64.zip";
    hash = "sha256-APIFQC5k6J0K5Q/e5poW8wKGL67NUbqKTJL4Ohd1K18=";
    url = "https://mikaygo.itch.io/ddm";
  };

  strictDeps = true;

  nativeBuildInputs = [
    copyDesktopItems
    makeWrapper
    unzip
  ];

  dontConfigure = true;
  dontBuild = true;

  installPhase =
    ''
      runHook preInstall

      mkdir -p $out/{bin,share/icons/hicolor/512x512/apps,share/ddm}

      mv -t $out/share/ddm/ ./resources/app/*
      ln -s $out/share/ddm/icon.png $out/share/icons/hicolor/512x512/apps/ddm.png

      makeWrapper ${lib.getExe electron} $out/bin/ddm \
        --add-flags "\''${NIXOS_OZONE_WL:+\''${WAYLAND_DISPLAY:+--ozone-platform-hint=auto --enable-features=WaylandWindowDecorations --enable-wayland-ime=true}}" \
        --add-flags "$out/share/ddm"

      # Install externally-downloaded campaign packs & cube lists
    ''
    + lib.concatMapStringsSep "\n" (campaignZip: ''
      unzip "${campaignZip}" -d $out/share/ddm/campaigns/
    '') campaigns
    + lib.concatMapStringsSep "\n" (cubeFile: ''
      cp "${cubeFile}" $out/share/ddm/cubes/
    '') cubes
    + ''

      runHook postInstall
    '';

  desktopItems = [
    (makeDesktopItem {
      name = "ddm";
      desktopName = "Dungeon Duel Monsters";
      comment = "A Tabletop Yugioh Experience";
      exec = "ddm";
      terminal = false;
      icon = "ddm";
    })
  ];

  meta = {
    description = "Tabletop Yugioh Experience";
    homepage = "https://dungeonduelmonsters.com";
    changelog = "https://mikaygo.itch.io/ddm/devlog";
    license = lib.licenses.unfree;
    mainProgram = "ddm";
    maintainers = with lib.maintainers; [ OPNA2608 ];
    platforms = lib.platforms.linux;
  };
})
