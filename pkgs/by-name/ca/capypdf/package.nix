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
  darwinMinVersionHook,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "capypdf";
  version = "0.18.0";

  outputs = [
    "out"
    "dev"
  ];

  src = fetchFromGitHub {
    owner = "jpakkane";
    repo = "capypdf";
    rev = finalAttrs.version;
    hash = "sha256-FivwBSpaIpkdKPYk7FuwpcBCYq59XH7SouA47rmGSaQ=";
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
  ]
  # error: 'to_chars' is unavailable: introduced in macOS 13.3
  ++ lib.optional stdenv.hostPlatform.isDarwin (darwinMinVersionHook "13.3");

  meta = {
    description = "Fully color managed PDF generation library";
    homepage = "https://github.com/jpakkane/capypdf";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ jtojnar ];
    mainProgram = "capypdf";
    platforms = lib.platforms.all;
  };
})
