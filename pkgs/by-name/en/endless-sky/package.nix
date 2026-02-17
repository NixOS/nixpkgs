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
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "endless-sky";
  version = "0.11.0";

  src = fetchFromGitHub {
    owner = "endless-sky";
    repo = "endless-sky";
    tag = "v${finalAttrs.version}";
    hash = "sha256-zeLM3n6pm5FxT+GO3dtJwDFKHs8boUuQBShU/PDCeFA=";
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

  meta = {
    description = "Sandbox-style space exploration game similar to Elite, Escape Velocity, or Star Control";
    mainProgram = "endless-sky";
    homepage = "https://endless-sky.github.io/";
    license = with lib.licenses; [
      gpl3Plus
      cc-by-sa-30
      cc-by-sa-40
      publicDomain
    ];
    maintainers = with lib.maintainers; [
      _360ied
      lilacious
    ];
    platforms = lib.platforms.linux; # Maybe other non-darwin Unix
  };
})
