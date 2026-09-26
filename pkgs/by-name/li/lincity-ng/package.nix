{
  stdenv,
  sdl3,
  sdl3-image,
  sdl3-mixer,
  sdl3-ttf,
  cmake,
  fetchFromGitHub,
  fmt,
  lib,
  libwebp,
  libtiff,
  libx11,
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
  version = "2.15.0";

  src = fetchFromGitHub {
    owner = "lincity-ng";
    repo = "lincity-ng";
    tag = "lincity-ng-${finalAttrs.version}";
    hash = "sha256-NgOMbFsK/8njP3hOT9N9E9TRipSW+7CAw1oVDW1F5QU=";
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
    sdl3
    sdl3-image
    sdl3-mixer
    sdl3-ttf
    libx11
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
    -I${lib.getDev sdl3-image}/include/SDL3
    -I${lib.getDev sdl3-mixer}/include/SDL3
  ";

  meta = {
    homepage = "https://github.com/lincity-ng/lincity-ng";
    description = "City building game";
    mainProgram = "lincity-ng";
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [
      raskin
      iedame
    ];
    platforms = lib.platforms.linux;
  };
})
