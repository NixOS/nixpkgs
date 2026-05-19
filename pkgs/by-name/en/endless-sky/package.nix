{
  lib,
  stdenv,
  fetchFromGitHub,
  SDL2,
  libavif,
  libpng,
  libjpeg,
  libogg,
  libx11,
  flac,
  glew,
  openal,
  cmake,
  pkg-config,
  libmad,
  libuuid,
  minizip,
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "endless-sky";
  version = "0.11.1";

  src = fetchFromGitHub {
    owner = "endless-sky";
    repo = "endless-sky";
    tag = "v${finalAttrs.version}";
    hash = "sha256-QXLIHAAdpK6lvKv0471KsiB+B06RKUfYoUNYKi8NAlg=";
  };

  patches = [
    ./fixes.patch
  ];

  postPatch = ''
    # the trailing slash is important!!
    # endless sky naively joins the paths with string concatenation
    # so it's essential that there be a trailing slash on the resources path
    substituteInPlace source/Files.cpp \
      --replace-fail '%NIXPKGS_RESOURCES_PATH%' "$out/share/games/endless-sky/"
  '';

  enableParallelBuilding = true;

  nativeBuildInputs = [
    cmake
    pkg-config
  ];

  buildInputs = [
    SDL2
    libavif
    libpng
    libjpeg
    libogg
    libx11
    flac
    glew
    openal
    libmad
    libuuid
    minizip
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Sandbox-style space exploration game similar to Elite, Escape Velocity, or Star Control";
    longDescription = ''
      Endless Sky is a sandbox-style space exploration game. You start as the captain
      of a tiny spaceship and can choose what to do from there. The game includes a
      major plot line and many minor missions, but you can play as a merchant, bounty
      hunter, or explorer entirely at your own discretion. Trade goods between star
      systems, upgrade your ship, recruit a fleet, and uncover alien civilisations
      beyond the boundaries of human space.
    '';
    mainProgram = "endless-sky";
    homepage = "https://endless-sky.github.io/";
    changelog = "https://github.com/endless-sky/endless-sky/blob/v${finalAttrs.version}/changelog";
    license = with lib.licenses; [
      gpl3Plus
      cc-by-sa-30
      cc-by-sa-40
      publicDomain
    ];
    maintainers = with lib.maintainers; [
      _360ied
      lilacious
      philocalyst
    ];
    platforms = lib.platforms.all;
  };
})
