{
  lib,
  stdenv,
  targetPlatform,
  fetchurl,
  python312,
  SDL2,
  libvorbis,
  openal,
  curl,
  gnugrep,
  libgcc,
  makeWrapper,
  makeDesktopItem,
  autoPatchelfHook,
  copyDesktopItems,
  writeShellApplication,
  commandLineArgs ? "",
  genericUpdater,
}:
let
  archive =
    {
      x86_64-linux = {
        name = "BombSquad_Linux_x86_64";
        hash = "sha256-ICjaNZSCUbslB5pELbI4e+1zXWrZzkCkv69jLRx4dr0=";
      };
      aarch-64-linux = {
        name = "BombSquad_Linux_Arm64";
        hash = "sha256-w42qhioZ9JRm004WEKzsJ3G1u09tLuPvTy8qV3DuglI=";
      };
    }
    .${targetPlatform.system} or (throw "${targetPlatform.system} is unsupported.");
in
stdenv.mkDerivation (finalAttrs: {
  pname = "bombsquad";
  version = "1.7.37";
  sourceRoot = ".";
  src = fetchurl {
    url = "https://files.ballistica.net/bombsquad/builds/${archive.name}_${finalAttrs.version}.tar.gz";
    inherit (archive) hash;
  };

  bombsquadIcon = fetchurl {
    url = "https://files.ballistica.net/bombsquad/promo/BombSquadIcon.png";
    hash = "sha256-MfOvjVmjhLejrJmdLo/goAM9DTGubnYGhlN6uF2GugA=";
  };

  nativeBuildInputs = [
    python312
    SDL2
    libvorbis
    openal
    libgcc
    makeWrapper
    autoPatchelfHook
    copyDesktopItems
  ];

  desktopItems = [
    (makeDesktopItem {
      name = "bombsquad";
      genericName = "bombsquad";
      desktopName = "BombSquad";
      icon = "bombsquad";
      exec = "bombsquad";
      comment = "An explosive arcade-style party game.";
      categories = [ "Game" ];
    })
  ];

  installPhase = ''
    runHook preInstall

    base=${archive.name}_${finalAttrs.version}

    install -m755 -D $base/bombsquad $out/bin/bombsquad
    install -dm755 $base/ba_data $out/usr/share/bombsquad/ba_data
    cp -r $base/ba_data $out/usr/share/bombsquad/

    wrapProgram "$out/bin/bombsquad" \
      --add-flags ${lib.escapeShellArg commandLineArgs} \
      --add-flags "-d $out/usr/share/bombsquad"

    install -Dm755 ${finalAttrs.bombsquadIcon} $out/usr/share/icons/hicolor/32x32/apps/bombsquad.png

    runHook postInstall
  '';

  passthru.updateScript = genericUpdater {
    versionLister = lib.getExe (writeShellApplication {
      name = "bombsquad-versionLister";
      runtimeInputs = [
        curl
        gnugrep
      ];
      text = ''
        curl -sL "https://files.ballistica.net/bombsquad/builds/CHANGELOG.md" \
            | grep -oP '^### \K\d+\.\d+\.\d+' \
            | head -n 1
      '';
    });
  };

  meta = {
    description = "Free, multiplayer, arcade-style game for up to eight players that combines elements of fighting games and first-person shooters (FPS)";
    homepage = "https://ballistica.net";
    changelog = "https://ballistica.net/downloads?display=changelog";
    license = with lib.licenses; [
      mit
      unfree
    ];
    maintainers = with lib.maintainers; [
      syedahkam
      coffeeispower
    ];
    mainProgram = "bombsquad";
    platforms = lib.platforms.linux;
  };
})
