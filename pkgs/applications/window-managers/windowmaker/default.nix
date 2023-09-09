{ lib
, stdenv
, fetchurl
, pkg-config
, libX11
, libXext
, libXft
, libXmu
, libXinerama
, libXrandr
, libXpm
, imagemagick
, libpng
, libjpeg
, libexif
, libtiff
, giflib
, libwebp
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "windowmaker";
  version = "0.95.9";

  src = fetchurl {
    url = "http://windowmaker.org/pub/source/release/WindowMaker-${finalAttrs.version}.tar.gz";
    hash = "sha256-8iNY/2AwFnDh4rUC+q0PLaf/iXZjLVOPlf5GOOnGtxQ=";
  };

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    giflib
    imagemagick
    libX11
    libXext
    libXft
    libXinerama
    libXmu
    libXpm
    libXrandr
    libexif
    libjpeg
    libpng
    libtiff
    libwebp
  ];

  configureFlags = [
    "--disable-magick" # Many distros reported imagemagick fails to be found
    "--enable-modelock"
    "--enable-randr"
    "--enable-webp"
    "--with-x"
  ];

  meta = {
    homepage = "http://windowmaker.org/";
    description = "NeXTSTEP-like window manager";
    longDescription = ''
      Window Maker is an X11 window manager originally designed to provide
      integration support for the GNUstep Desktop Environment. In every way
      possible, it reproduces the elegant look and feel of the NEXTSTEP user
      interface. It is fast, feature rich, easy to configure, and easy to
      use. It is also free software, with contributions being made by
      programmers from around the world.
    '';
    changelog = "https://www.windowmaker.org/news/";
    license = lib.licenses.gpl2Plus;
    mainProgram = "wmaker";
    maintainers = [ lib.maintainers.AndersonTorres ];
    platforms = lib.platforms.linux;
  };
})
