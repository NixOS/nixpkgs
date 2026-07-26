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
  sdl3,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "principia";
  version = "2026.07.15";

  src = fetchFromGitHub {
    owner = "Bithack";
    repo = "principia";
    tag = finalAttrs.version;
    hash = "sha256-kIUi5vXXI3R2P4ZsbfLdfmRexfpk0zWZAMhUjreZPuA=";
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
    sdl3
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
