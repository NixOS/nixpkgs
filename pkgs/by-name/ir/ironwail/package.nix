{
  lib,
  stdenv,
  fetchFromGitHub,
  SDL2,
  copyDesktopItems,
  curl,
  flac,
  libGL,
  libmad,
  libogg,
  libopus,
  libvorbis,
  libxmp,
  makeDesktopItem,
  nix-update-script,
  opusfile,
  pkg-config,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "ironwail";
  version = "0.8.2";

  __structuredAttrs = true;
  strictDeps = true;

  src = fetchFromGitHub {
    owner = "andrei-drexler";
    repo = "ironwail";
    tag = "v${finalAttrs.version}";
    hash = "sha256-h/3jZ97tzCsy2E5/GCrxMWfVG/LeteEYhN2b7Q8V1/Y=";
  };

  sourceRoot = "${finalAttrs.src.name}/Quake";

  postPatch = ''
    substituteInPlace sys_sdl_unix.c \
      --replace-fail "host_parms->exedir = Sys_GetExeDir ();" \
                     "host_parms->exedir = \"$out/share/ironwail\";"
  '';

  nativeBuildInputs = [
    copyDesktopItems
    pkg-config
  ];

  buildInputs = [
    SDL2
    curl
    flac
    libGL
    libmad
    libogg
    libopus
    libvorbis
    libxmp
    opusfile
  ];

  makeFlags = [
    "DO_USERDIRS=1"
    "USE_SDL2=1"
    "SDL_CONFIG=${lib.getExe' (lib.getDev SDL2) "sdl2-config"}"
    "USE_CODEC_WAVE=1"
    "USE_CODEC_MP3=1"
    "USE_CODEC_VORBIS=1"
    "USE_CODEC_FLAC=1"
    "USE_CODEC_OPUS=1"
    "USE_CODEC_MIKMOD=0"
    "USE_CODEC_UMX=0"
    "USE_CODEC_XMP=1"
    "MP3LIB=mad"
    "VORBISLIB=vorbis"
  ];

  enableParallelBuilding = true;

  installPhase = ''
    runHook preInstall

    install -Dm755 ironwail -t $out/bin
    install -Dm644 ironwail.pak -t $out/share/ironwail
    install -Dm644 ../Misc/QuakeSpasm_512.png $out/share/icons/hicolor/512x512/apps/ironwail.png

    runHook postInstall
  '';

  desktopItems = [
    (makeDesktopItem {
      name = "ironwail";
      categories = [
        "Game"
        "ActionGame"
        "Shooter"
      ];
      comment = "High-performance QuakeSpasm fork";
      desktopName = "Ironwail";
      exec = "ironwail";
      icon = "ironwail";
    })
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Fork of the QuakeSpasm engine for iD software's Quake";
    longDescription = ''
      Ironwail is a fork of QuakeSpasm with focus on high performance instead of
      compatibility.
      It features the ability to play the 2021 re-release content with no setup
      required, a mods menu for quick access to installation of mods, and ease of
      switching to installed mods.
      It also include various visual features as well as improved limits for playing
      larger levels with less performance impacts.
    '';
    homepage = "https://github.com/andrei-drexler/ironwail";
    changelog = "https://github.com/andrei-drexler/ironwail/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.gpl2Plus;
    maintainers = [ lib.maintainers.necrophcodr ];
    platforms = lib.platforms.linux;
    mainProgram = "ironwail";
  };
})
