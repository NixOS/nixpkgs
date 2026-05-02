{
  lib,
  stdenv,
  fetchurl,
  python313,
  SDL2,
  cairo,
  pango,
  libvorbis,
  openal,
  curl,
  gnugrep,
  gnused,
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
        hash = "sha256-VHhDRzB7sSvb3Ou/Sg+PjTKFDG9sKsXueu2qLNfC06k=";
      };
      aarch64-linux = {
        name = "BombSquad_Linux_Arm64";
        hash = "sha256-usrhPOsXkJZk0HCSBIGnc4qdIu2SW7STp6Y/e6RmZlM=";
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
  # Note: This version trails behind the latest version by one since the latest
  # version sometimes gets replaced for minor updates. The builds in /old/ are
  # stable.
  version = "1.7.61";

  src = fetchurl {
    url = "https://files.ballistica.net/bombsquad/builds/old/${archive.name}_${finalAttrs.version}.tar.gz";
    inherit (archive) hash;
  };

  sourceRoot = "${archive.name}_${finalAttrs.version}";

  buildInputs = [
    SDL2
    cairo
    libgcc
    libvorbis
    openal
    pango
    python313
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

    install -Dm755 ${bombsquadIcon} $out/share/icons/bombsquad.png

    runHook postInstall
  '';

  passthru.updateScript = genericUpdater {
    versionLister = lib.getExe (writeShellApplication {
      name = "bombsquad-versionLister";
      runtimeInputs = [
        curl
        gnugrep
        gnused
      ];
      text = ''
        curl -sL "https://files.ballistica.net/bombsquad/builds/CHANGELOG.md" \
            | grep -oP '^### \K\d+\.\d+\.\d+' \
            | sed -n 2p
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
      mrmaxmeier
    ];
    mainProgram = "bombsquad";
    platforms = lib.platforms.linux;
  };
})
