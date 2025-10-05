{
  lib,
  stdenv,
  fetchFromGitHub,
  meson,
  ninja,
  pkg-config,
  freetype,
  lcms2,
  libjpeg,
  libpng,
  libtiff,
  zlib,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "capypdf";
  version = "0.17.0";

  outputs = [
    "out"
    "dev"
  ];

  src = fetchFromGitHub {
    owner = "jpakkane";
    repo = "capypdf";
    rev = finalAttrs.version;
    hash = "sha256-hdutgZhJwUi+wwtYt3+hSiyBImchUtbpVd0RCPWEr0Q=";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
  ];

  buildInputs = [
    freetype
    lcms2
    libpng
    libjpeg
    libtiff
    zlib
  ];

  meta = {
    description = "Fully color managed PDF generation library";
    homepage = "https://github.com/jpakkane/capypdf";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ jtojnar ];
    mainProgram = "capypdf";
    platforms = lib.platforms.all;
  };
})
