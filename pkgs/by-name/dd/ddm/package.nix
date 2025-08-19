{
  stdenvNoCC,
  lib,
  requireFile,
  asar,
  copyDesktopItems,
  electron,
  makeDesktopItem,
  makeWrapper,
  unzip,

  campaigns ? [ ],
  cubes ? [ ],
  constructed ? [ ],
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "ddm";
  version = "4.1.0";

  src = requireFile {
    name = "DungeonDuelMonsters-linux-x64.zip";
    hash = "sha256-gq2nGwpaStqaVI1pL63xygxOI/z53o+zLwiKizG98Ks=";
    url = "https://mikaygo.itch.io/ddm";
  };

  strictDeps = true;

  nativeBuildInputs = [
    asar
    copyDesktopItems
    makeWrapper
    unzip
  ];

  dontConfigure = true;
  dontBuild = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/{bin,share/icons/hicolor/512x512/apps,share/ddm}

    asar extract ./resources/app.asar $out/share/ddm/

    patch -d $out/share/ddm/ -p1 < ${./0001-Make-findPath-its-calls-behave-well-with-store.patch}

    ln -s $out/share/ddm/icon.png $out/share/icons/hicolor/512x512/apps/ddm.png

    makeWrapper ${lib.getExe electron} $out/bin/ddm \
      --add-flags "\''${NIXOS_OZONE_WL:+\''${WAYLAND_DISPLAY:+--ozone-platform-hint=auto --enable-features=WaylandWindowDecorations --enable-wayland-ime=true}}" \
      --add-flags "$out/share/ddm"

    # Install externally-downloaded campaign packs and cube & constructed lists
    mkdir $out/share/ddm/{campaigns,cubes,constructed}
  ''
  + lib.concatMapStringsSep "\n" (campaignZip: ''
    unzip "${campaignZip}" -d $out/share/ddm/campaigns/
  '') campaigns
  + lib.concatMapStringsSep "\n" (cubeFile: ''
    cp "${cubeFile}" $out/share/ddm/cubes/
  '') cubes
  + lib.concatMapStringsSep "\n" (constructedFile: ''
    cp "${constructedFile}" $out/share/ddm/constructed/
  '') constructed
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
