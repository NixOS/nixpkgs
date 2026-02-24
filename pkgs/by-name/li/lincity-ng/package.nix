{
  stdenv,
  SDL2,
  SDL2_image,
  SDL2_mixer,
  SDL2_ttf,
  cmake,
  fetchFromGitHub,
  fmt,
  lib,
  libwebp,
  libtiff,
  libX11,
  libxml2,
  libxmlxx5,
  libxslt,
  pkg-config,
  xorgproto,
  zlib,
  gettext,
  include-what-you-use,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "lincity-ng";
  version = "2.14.2";

  src = fetchFromGitHub {
    owner = "lincity-ng";
    repo = "lincity-ng";
    tag = "lincity-ng-${finalAttrs.version}";
    hash = "sha256-HW+bB9xnrok8tWKIJJUt3Qgo5e9HmI6NZORG4PazmEM=";
  };

  hardeningDisable = [ "format" ];

  strictDeps = true;

  nativeBuildInputs = [
    cmake
    pkg-config
    gettext
    include-what-you-use
    libxml2
    libxslt
  ];

  buildInputs = [
    fmt
    SDL2
    SDL2_image
    SDL2_mixer
    SDL2_ttf
    libX11
    libwebp
    libtiff
    libxmlxx5
    libxml2
    libxslt
    xorgproto
    zlib
  ];

  cmakeFlags = [
    "-DLIBXML2_LIBRARY=${lib.getLib libxml2}/lib/libxml2${stdenv.hostPlatform.extensions.sharedLibrary}"
    "-DLIBXML2_XMLCATALOG_EXECUTABLE=${lib.getBin libxml2}/bin/xmlcatalog"
    "-DLIBXML2_XMLLINT_EXECUTABLE=${lib.getBin libxml2}/bin/xmllint"
  ];

  env.NIX_CFLAGS_COMPILE = "
    -I${lib.getDev SDL2_image}/include/SDL2
    -I${lib.getDev SDL2_mixer}/include/SDL2
  ";

  meta = {
    homepage = "https://github.com/lincity-ng/lincity-ng";
    description = "City building game";
    mainProgram = "lincity-ng";
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [ raskin ];
    platforms = lib.platforms.linux;
  };
})
