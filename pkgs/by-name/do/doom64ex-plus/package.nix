{
  lib,
  stdenv,
  fetchFromGitHub,
  SDL2,
  SDL2_net,
  fluidsynth,
  libGLU,
  libpng,
  pkg-config,
  makeDesktopItem,
  copyDesktopItems,
}:

let
  buildScript = if stdenv.isAarch64 then "build_aarch64.sh" else "build.sh";
in

stdenv.mkDerivation (finalAttrs: {
  pname = "doom64ex-plus";
  version = "3.6.5.9";

  src = fetchFromGitHub {
    owner = "atsb";
    repo = "Doom64EX-Plus";
    rev = finalAttrs.version;
    hash = "sha256-2s4rIfSLHNdbKQOefnQzK+RCQGrM01eNRyAzC8yP8EE=";
  };

  nativeBuildInputs = [
    libGLU
    pkg-config
    copyDesktopItems
  ];

  buildInputs = [
    fluidsynth
    libpng
    SDL2
    SDL2_net
  ];

  env.NIX_CFLAGS_COMPILE = toString [
    "-DDOOM_UNIX_INSTALL" # Needed for config to be placed in ~/.local/share/doom64ex-plus
  ];

  sourceRoot = "${finalAttrs.src.name}/src/engine";

  buildPhase = ''
    sh ${buildScript}
  '';

  desktopItems = [
    (makeDesktopItem {
      name = "DOOM64EX-Plus";
      exec = "DOOM64EX-Plus";
      icon = "DOOM64EX-Plus";
      desktopName = "DOOM 64 EX+";
      comment = "An improved, modern version of Doom64EX";
      categories = [ "Game" ];
    })
  ];

  installPhase = ''
    runHook preInstall

    install -Dm644 -t $out/share/icons/hicolor/256x256/apps/DOOM64EX-Plus.png $src/src/engine/doom64ex-plus.png
    install -Dm444 -t $out/bin $src/doom64ex-plus.wad $src/doomsnd.sf2
    install -Dm755 -t $out/bin DOOM64EX-Plus

    runHook postInstall
  '';

  meta = {
    description = "An improved, modern version of Doom64EX";
    homepage = "https://github.com/atsb/Doom64EX-Plus.git";
    license = lib.licenses.gpl2Only;
    longDescription = ''
      Copy doomsnd.sf2 and doom64ex-plus.wad from the
      nix store to ~/.local/share/doom64ex-plus

      You will also need DOOM64.WAD from Nightdive Studios'
      DOOM 64 Remastered release. To extract it from the GOG
      installer, run:
      ``` bash
      nix-shell -p innoextract.out --run \
      'innoextract -g /path/to/installer.exe \
      -I DOOM64.WAD -d ~/.local/share/doom64ex-plus'
      ```
    '';
    maintainers = with lib.maintainers; [ keenanweaver ];
    mainProgram = "DOOM64EX-Plus";
    platforms = [ "x86_64-linux" ]; #TODO: Darwin & aarch64 builds
  };
})
