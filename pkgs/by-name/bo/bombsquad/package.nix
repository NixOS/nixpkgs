{
  lib,
  stdenv,
  fetchurl,
  python312,
  SDL2,
  libvorbis,
  openal,
  curl,
  gnugrep,
  libgcc,
  makeBinaryWrapper,
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
        hash = "sha256-/m0SOQbHssk0CqZJPRLK9YKphup3dtMqkbWGzqcF0+g=";
      };
    }
    .${stdenv.targetPlatform.system} or (throw "${stdenv.targetPlatform.system} is unsupported.");

  bombsquadIcon = fetchurl {
    url = "https://files.ballistica.net/bombsquad/promo/BombSquadIcon.png";
    hash = "sha256-MfOvjVmjhLejrJmdLo/goAM9DTGubnYGhlN6uF2GugA=";
  };

in
stdenv.mkDerivation (finalAttrs: {
  pname = "bombsquad";
  version = "1.7.37";

  src = fetchurl {
    url = "https://web.archive.org/web/20240825230506if_/https://files.ballistica.net/bombsquad/builds/${archive.name}_${finalAttrs.version}.tar.gz";
    inherit (archive) hash;
  };

  sourceRoot = "${archive.name}_${finalAttrs.version}";

  buildInputs = [
    SDL2
    libgcc
    libvorbis
    openal
    python312
  ];

  nativeBuildInputs = [
    autoPatchelfHook
    copyDesktopItems
    makeBinaryWrapper
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

    mkdir -p $out/bin $out/libexec $out/share/bombsquad/ba_data

    install -Dm555 -t $out/libexec ${finalAttrs.meta.mainProgram}
    cp -r ba_data $out/share/bombsquad

    makeWrapper "$out/libexec/${finalAttrs.meta.mainProgram}" "$out/bin/${finalAttrs.meta.mainProgram}" \
      --add-flags ${lib.escapeShellArg commandLineArgs} \
      --add-flags "-d $out/share/bombsquad"

    install -Dm755 ${bombsquadIcon} $out/share/icons/hicolor/1024x1024/apps/bombsquad.png

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
