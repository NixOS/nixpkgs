{
  lib,
  sdl3,
  darwin,
  fetchurl,
  libjpeg,
  libpng,
  libavif,
  libtiff,
  libwebp,
  stdenv,
  zlib,
  cmake,
  ninja,
  validatePkgConfig,
  # Boolean flags
  enableTests ? true,
  useImageIO ? stdenv.hostPlatform.isDarwin,
}:

let
  inherit (darwin.apple_sdk.frameworks) Foundation;
in
stdenv.mkDerivation (finalAttrs: {
  pname = "sdl3-image";
  version = "3.2.0";

  src = fetchurl {
    url = "https://www.libsdl.org/projects/SDL_image/release/SDL3_image-${finalAttrs.version}.tar.gz";
    hash = "sha256-FpC66nGytN7ZiVEmzdvAOhAAsCfQmaT7RmnE0j1zsZ8=";
  };

  nativeBuildInputs = [
    sdl3
    cmake
    ninja
    validatePkgConfig
  ];

  buildInputs = [
    sdl3
    libjpeg
    libpng
    libtiff
    libwebp
    libavif
    zlib
  ] ++ lib.optionals stdenv.hostPlatform.isDarwin [ Foundation ];

  prePatch = ''
    substituteInPlace cmake/sdl3-image.pc.in \
      --replace-fail '@CMAKE_INSTALL_LIBDIR@' 'lib' \
      --replace-fail '@CMAKE_INSTALL_INCLUDEDIR@' 'include'
  '';

  cmakeFlags =
    [
      # Disable dynamically loaded dependencies
      "-DSDLIMAGE_WEBP_SHARED=OFF"
      "-DSDLIMAGE_TIF_SHARED=OFF"
      "-DSDLIMAGE_PNG_SHARED=OFF"
      "-DSDLIMAGE_AVIF_SHARED=OFF"
      "-DSDLIMAGE_JPG_SHARED=OFF"
    ]
    ++ lib.optionals enableTests [
      # Build unit tests
      "-DSDLIMAGE_TESTS=ON"
    ]
    ++ lib.optionals useImageIO [
      # on darwin use native imageio
      "-DSDLIMAGE_BACKEND_IMAGEIO=ON"
    ];

  strictDeps = true;

  enableParallelBuilding = true;

  meta = {
    description = "SDL image library";
    homepage = "https://github.com/libsdl-org/SDL_image";
    license = lib.licenses.zlib;
    maintainers = lib.teams.sdl.members;
    inherit (sdl3.meta) platforms;
  };
})
