{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  pkg-config,
  wrapGAppsHook3,

  curl,
  freetype,
  gtk3,
  libGL,
  libjpeg,
  libpng,
  SDL2,
  SDL2_gfx,
  SDL2_image,
  SDL2_mixer,
  SDL2_ttf,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "principia";
  version = "2026.06.19";

  src = fetchFromGitHub {
    owner = "Bithack";
    repo = "principia";
    rev = finalAttrs.version;
    hash = "sha256-LYU8ctsEndBS3AGuQ9BtFaWR6RgTyoG4WAd91+B4zwY=";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
    wrapGAppsHook3
  ];

  buildInputs = [
    curl
    freetype
    gtk3
    libGL
    libjpeg
    libpng
    SDL2
    SDL2_gfx
    SDL2_image
    SDL2_mixer
    SDL2_ttf
  ];

  cmakeFlags = [
    # Remove when https://github.com/NixOS/nixpkgs/issues/144170 is fixed
    (lib.cmakeFeature "CMAKE_INSTALL_BINDIR" "bin")
  ];

  meta = {
    changelog = "https://principia-web.se/wiki/Changelog#${
      lib.replaceStrings [ "." ] [ "-" ] finalAttrs.version
    }";
    description = "Physics-based sandbox game";
    mainProgram = "principia";
    homepage = "https://principia-web.se/";
    downloadPage = "https://principia-web.se/download";
    license = lib.licenses.bsd3;
    maintainers = [ lib.maintainers.fgaz ];
    platforms = lib.platforms.linux;
  };
})
