{
  lib,
  stdenv,
  fetchFromGitHub,
  sdl3,
  fluidsynth,
  libGL,
  libGLU,
  libpng,
  zlib,
  pkg-config,
  makeDesktopItem,
  copyDesktopItems,
  installShellFiles,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "doom64ex-plus";
  version = "4.0.0.3.1";

  src = fetchFromGitHub {
    owner = "atsb";
    repo = "Doom64EX-Plus";
    tag = "4.0.0.3.1";
    hash = "sha256-WYA8JKOtqx53JrdpvBPUXNheeG3rZikpVHTwT0LBWl4=";
  };

  strictDeps = true;
  enableParallelBuilding = true;

  nativeBuildInputs = [
    pkg-config
    copyDesktopItems
    installShellFiles
  ];

  buildInputs = [
    fluidsynth
    libGL
    libGLU
    libpng
    sdl3
    zlib
  ];

  desktopItems = [
    (makeDesktopItem {
      name = "DOOM64EX-Plus";
      exec = "DOOM64EX-Plus";
      icon = "doom64ex-plus";
      desktopName = "DOOM 64 EX+";
      comment = "Improved, modern version of Doom64EX";
      categories = [ "Game" ];
    })
  ];

  installPhase = ''
    runHook preInstall
    install -Dm644 -t $out/share/icons/hicolor/256x256/apps $src/src/engine/doom64ex-plus.png
    install -Dm444 -t $out/share/doom64ex-plus $src/doom64ex-plus.wad $src/doomsnd.sf2
    installBin DOOM64EX-Plus
    installManPage $src/doom64ex-plus.6
    runHook postInstall
  '';

  preBuild = ''
    makeFlagsArray+=("CC=$CC")
    buildFlagsArray+=('CFLAGS=-DDOOM_UNIX_INSTALL -DDOOM_UNIX_SYSTEM_DATADIR=\"$(out)/share/doom64ex-plus\"')
  '';

  meta = {
    description = "Improved, modern version of Doom64EX";
    homepage = "https://github.com/atsb/Doom64EX-Plus";
    license = lib.licenses.gpl2Only;
    longDescription = ''
      You will need DOOM64.WAD from Nightdive Studios'
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
    platforms = lib.platforms.unix;
  };
})
