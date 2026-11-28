{
  lib,
  stdenv,
  fetchFromGitHub,
  SDL2,
  SDL2_image,
  SDL2_mixer,
  SDL2_net,
  SDL2_ttf,
  libGL,
  luajit,
  ncurses,
  zlib,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "hydra-slayer";
  version = "18.3-unstable-2025-01-28";

  src = fetchFromGitHub {
    owner = "zenorogue";
    repo = "noteye";
    rev = "55bb69d716a9fb269c6364f9df89d4bc260cb1a1";
    hash = "sha256-QUI+5yChNJzRTcxWOJUon5ESIqg6zQs5yVPbew6AgOI=";
  };

  strictDeps = true;
  __structuredAttrs = true;

  env.NIX_CFLAGS_COMPILE = "-I${lib.getDev SDL2}/include/SDL2";

  buildInputs = [
    SDL2
    SDL2_image
    SDL2_mixer
    SDL2_net
    SDL2_ttf
    libGL
    luajit
    ncurses
    zlib
  ];

  postPatch = ''
    substituteInPlace src/Makefile \
      --replace-fail ' -Werror' "" \
      --replace-fail '-I/usr/include/lua5.1' "" \
      --replace-fail '-lcurses' '-lncursesw' \
      --replace-fail '/usr/share/noteye' "$out/share/noteye"
    substituteInPlace src/hydraslayer.sh \
      --replace-fail '/usr/share/noteye' "$out/share/noteye"
  '';

  preBuild = ''
    cd src
  '';

  enableParallelBuilding = true;

  installPhase = ''
    runHook preInstall

    install -Dm755 ../noteye       $out/share/noteye/noteye
    install -Dm755 ../libnoteye.so $out/share/noteye/libnoteye.so

    mkdir -p $out/share/noteye/gfx/dawnlike
    cp ../gfx/*.png ../gfx/*.jpeg ../gfx/*.ttf ../gfx/*.otf $out/share/noteye/gfx/
    cp -r ../gfx/dawnlike/{Items,Objects,Characters,GUI,README.txt} \
        $out/share/noteye/gfx/dawnlike/

    mkdir -p $out/share/noteye/sound
    cp -r ../sound/hydra-old ../sound/hydra-new $out/share/noteye/sound/

    mkdir -p $out/share/noteye/{common,games}
    install -Dm644 ../common/*.noe -t $out/share/noteye/common/
    install -Dm644 ../games/*.noe  -t $out/share/noteye/games/

    install -Dm755 hydraslayer.sh $out/bin/hydraslayer

    runHook postInstall
  '';

  meta = {
    description = "Puzzle roguelike about slaying multi-headed mythological hydras";
    longDescription = ''
      Hydra Slayer is a turn-based puzzle roguelike in which the player must
      work out the optimal sequence of weapon attacks to slay hydras whose
      heads regrow after each cut. It is built on top of the NotEye engine
      (which is bundled here as the underlying runtime).
    '';
    homepage = "https://github.com/zenorogue/noteye";
    license = with lib.licenses; [
      gpl3Plus
      cc-by-sa-30
    ];
    mainProgram = "hydraslayer";
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [
      mikolajkniejski
    ];
  };
})
