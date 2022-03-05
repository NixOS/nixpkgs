{ lib
, stdenv
, fetchurl
, bison
, flex
, perl
, libpng
, giflib
, libjpeg
, alsa-lib
, readline
, libGLU
, libGL
, libXaw
, pkg-config
, gtk2
, SDL
, SDL_image
, autoreconfHook
, makeDesktopItem
, dos2unix
, xa
, file
}:

stdenv.mkDerivation rec {
  pname = "vice";
  version = "3.6.1";

  src = fetchurl {
    url = "mirror://sourceforge/vice-emu/vice-${version}.tar.gz";
    sha256 = "sha256-IN+EyFGq8vUABRCSf20xsy8mmRbTUUZcNm3Ar8ncFQw=";
  };

  nativeBuildInputs = [
    autoreconfHook
    bison
    dos2unix
    file
    flex
    pkg-config
  ];

  buildInputs = [
    alsa-lib
    giflib
    gtk2
    libGL
    libGLU
    libXaw
    libjpeg
    libpng
    perl
    readline
    SDL
    SDL_image
    xa
  ];
  dontDisableStatic = true;
  configureFlags = [ "--enable-fullscreen" "--enable-gnomeui" "--disable-pdf-docs" ];

  desktopItem = makeDesktopItem {
    name = "vice";
    exec = "x64";
    comment = "Commodore 64 emulator";
    desktopName = "VICE";
    genericName = "Commodore 64 emulator";
    categories = [ "Emulator" ];
  };

  preBuild = ''
    for i in src/resid src/resid-dtv
    do
      mkdir -pv $i/src
      ln -sv ../../wrap-u-ar.sh $i/src
    done
  '';

  postInstall = ''
    mkdir -p $out/share/applications
    cp ${desktopItem}/share/applications/* $out/share/applications
  '';

  meta = {
    description = "Commodore 64, 128 and other emulators";
    homepage = "https://vice-emu.sourceforge.io/";
    license = lib.licenses.gpl2Plus;
    maintainers = [ lib.maintainers.sander ];
    platforms = lib.platforms.linux;
  };
}
