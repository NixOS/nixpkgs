{
  lib,
  SDL2,
  darwin,
  fetchurl,
  giflib,
  libXpm,
  libjpeg,
  libpng,
  libtiff,
  libwebp,
  pkg-config,
  stdenv,
  zlib,
  # Boolean flags
  ## Darwin headless will hang when trying to run the SDL test program
  enableSdltest ? (!stdenv.hostPlatform.isDarwin),
}:

let
  inherit (darwin.apple_sdk.frameworks) Foundation;
in
stdenv.mkDerivation (finalAttrs: {
  pname = "SDL2_image";
  version = "2.8.2";

  src = fetchurl {
    url = "https://www.libsdl.org/projects/SDL_image/release/SDL2_image-${finalAttrs.version}.tar.gz";
    hash = "sha256-j0hrv7z4Rk3VjJ5dkzlKsCVc5otRxalmqRgkSCCnbdw=";
  };

  nativeBuildInputs = [
    SDL2
    pkg-config
  ];

  buildInputs = [
    SDL2
    giflib
    libXpm
    libjpeg
    libpng
    libtiff
    libwebp
    zlib
  ] ++ lib.optionals stdenv.hostPlatform.isDarwin [ Foundation ];

  configureFlags =
    [
      # Disable dynamically loaded dependencies
      (lib.enableFeature false "jpg-shared")
      (lib.enableFeature false "png-shared")
      (lib.enableFeature false "tif-shared")
      (lib.enableFeature false "webp-shared")
      (lib.enableFeature enableSdltest "sdltest")
    ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [
      # Don't use native macOS frameworks
      # Caution: do not set this as (!stdenv.hostPlatform.isDarwin) since it would be true
      # outside Darwin - and ImageIO does not exist outisde Darwin
      (lib.enableFeature false "imageio")
    ];

  strictDeps = true;

  enableParallelBuilding = true;

  meta = {
    description = "SDL image library";
    homepage = "https://github.com/libsdl-org/SDL_image";
    license = lib.licenses.zlib;
    maintainers = lib.teams.sdl.members ++ (with lib.maintainers; [ ]);
    platforms = lib.platforms.unix;
  };
})
