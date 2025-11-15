{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  zlib,
  boost,
  openal,
  glm,
  freetype,
  libGLU,
  SDL2,
  libepoxy,
  dejavu_fonts,
  inkscape,
  optipng,
  imagemagick,
  withCrashReporter ? !stdenv.hostPlatform.isDarwin,
  libsForQt5 ? null,
  curl ? null,
  gdb ? null,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "arx-libertatis";
  version = "1.2.1";

  src = fetchFromGitHub {
    owner = "arx";
    repo = "ArxLibertatis";
    tag = finalAttrs.version;
    hash = "sha256-GBJcsibolZP3oVOTSaiVqG2nMmvXonKTp5i/0NNODKY=";
  };

  nativeBuildInputs = [
    cmake
    inkscape
    imagemagick
    optipng
  ]
  ++ lib.optionals withCrashReporter [ libsForQt5.wrapQtAppsHook ];

  buildInputs = [
    zlib
    boost
    openal
    glm
    freetype
    libGLU
    SDL2
    libepoxy
  ]
  ++ lib.optionals withCrashReporter [
    libsForQt5.qtbase
    curl
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [ gdb ];

  cmakeFlags = [
    "-DDATA_DIR_PREFIXES=$out/share"
    "-DImageMagick_convert_EXECUTABLE=${imagemagick.out}/bin/convert"
    "-DImageMagick_mogrify_EXECUTABLE=${imagemagick.out}/bin/mogrify"
  ];

  dontWrapQtApps = true;

  postInstall = ''
    ln -sf \
      ${dejavu_fonts}/share/fonts/truetype/DejaVuSansMono.ttf \
      $out/share/games/arx/misc/dejavusansmono.ttf
  ''
  + lib.optionalString withCrashReporter ''
    wrapQtApp "$out/libexec/arxcrashreporter"
  '';

  meta = {
    description = "First-person role-playing game / dungeon crawler";
    longDescription = ''
      A cross-platform, open source port of Arx Fatalis, a 2002
      first-person role-playing game / dungeon crawler
      developed by Arkane Studios.
    '';
    homepage = "https://arx-libertatis.org/";
    license = lib.licenses.gpl3;
    maintainers = with lib.maintainers; [ rnhmjoj ];
    platforms = lib.platforms.linux;
  };

})
