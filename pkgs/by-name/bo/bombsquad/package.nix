{
  stdenv,
  lib,
  python3,
  SDL2,
  mesa,
  libGL,
  openal,
  libvorbis,
  fetchurl,
  makeWrapper,
  patchelf,
  copyDesktopItems,
  makeDesktopItem
}:
let
  runtimeDependencies = [
    python3
    SDL2
    libvorbis
    mesa
    stdenv.cc.cc.lib
    libGL
    openal
  ];
in
stdenv.mkDerivation (finalAttrs: {
  version = "1.7.33";
  pname = "bombsquad";

  src = fetchurl {
    url = "http://files.ballistica.net/bombsquad/builds/BombSquad_Linux_x86_64_${finalAttrs.version}.tar.gz";
    hash = "sha256-pfimBt1s4QP+6buPvTkSdmt5zj2NpXqJUfbxRirfz/o=";
  };

  sourceRoot = "BombSquad_Linux_x86_64_${finalAttrs.version}";

  dontConfigure = true;
  dontBuild = true;

  nativeBuildInputs = [
    patchelf
    makeWrapper
    copyDesktopItems
  ];

  desktopItems = [
    (makeDesktopItem {
      name = "Bombsquad";
      exec = "bombsquad";
      icon = fetchurl {
        url = "https://www.froemling.net/wp-content/uploads/2018/02/icon_clipped-1-150x150.png";
        hash = "sha256-x08rekyPzHe2FdQzo1EIZ3Rgg/OAcTbWCHoiKuGRBvU=";
      };
      comment = finalAttrs.meta.description;
      desktopName = "Bombsquad";
      genericName = "Bombsquad";
      startupWMClass = ".bombsquad-wrapped";
      categories = [ "Game" ];
    })
  ];

  installPhase = ''
    runHook preInstall
    copyDesktopItems
    mkdir -p $out/bin
    cp -r ba_data $out/ba_data
    install -Dm755 bombsquad -t $out/bin/
    runHook postInstall
  '';

  postFixup = ''
    patchelf \
      --set-rpath ${lib.makeLibraryPath runtimeDependencies} \
      --set-interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" \
      $out/bin/bombsquad
    wrapProgram $out/bin/bombsquad --chdir "$out"
  '';

  meta = with lib; {
    homepage = "https://ballistica.net/";
    description = "A party game to blow up your friends in various minigames from CTF to hockey";
    longDescription = ''
      Blow up your friends in mini-games ranging from capture-the-flag to hockey!
      Featuring 8 player local/networked multiplayer, gratuitous explosions,
      advanced ragdoll face-plant physics, pirates, ninjas, barbarians, insane chefs,
      and more.

      BombSquad supports touch screens as well as a variety of controllers so all
      your friends can get in on the action. You can even use phones and tablets
      as controllers via the free 'BombSquad Remote' app.

      Bombs away!
    '';
    platforms = [ "x86_64-linux" ];
    sourceProvenance = [ sourceTypes.binaryNativeCode ];
    maintainers = with maintainers; [ coffeeispower ];
    mainProgram = "bombsquad";
  };
})
