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

let
  desktopItems = [
    (makeDesktopItem {
      name = "x128";
      exec = "x128";
      comment = "VICE: C128 Emulator";
      desktopName = "VICE: C128 Emulator";
      genericName = "Commodore 128 emulator";
      categories = [ "System" ];
    })

    (makeDesktopItem {
      name = "x64";
      exec = "x64";
      comment = "VICE: C64 Emulator";
      desktopName = "VICE: C64 Emulator";
      genericName = "Commodore 64 emulator";
      categories = [ "System" ];
    })

    (makeDesktopItem {
      name = "x64dtv";
      exec = "x64dtv";
      comment = "VICE: C64 DTV Emulator";
      desktopName = "VICE: C64 DTV Emulator";
      genericName = "Commodore 64 DTV emulator";
      categories = [ "System" ];
    })

    (makeDesktopItem {
      name = "x64sc";
      exec = "x64sc";
      comment = "VICE: C64 SC Emulator";
      desktopName = "VICE: C64 SC Emulator";
      genericName = "Commodore 64 SC emulator";
      categories = [ "System" ];
    })

    (makeDesktopItem {
      name = "xcbm2";
      exec = "xcbm2";
      comment = "VICE: CBM-II B-Model Emulator";
      desktopName = "VICE: CBM-II B-Model Emulator";
      genericName = "CBM-II B-Model Emulator";
      categories = [ "System" ];
    })

    (makeDesktopItem {
      name = "xcbm5x0";
      exec = "xcbm5x0";
      comment = "VICE: CBM-II P-Model Emulator";
      desktopName = "VICE: CBM-II P-Model Emulator";
      genericName = "CBM-II P-Model Emulator";
      categories = [ "System" ];
    })

    (makeDesktopItem {
      name = "xpet";
      exec = "xpet";
      comment = "VICE: PET Emulator";
      desktopName = "VICE: PET Emulator";
      genericName = "Commodore PET Emulator";
      categories = [ "System" ];
    })

    (makeDesktopItem {
      name = "xplus4";
      exec = "xplus4";
      comment = "VICE: PLUS4 Emulator";
      desktopName = "VICE: PLUS4 Emulator";
      genericName = "Commodore PLUS4 Emulator";
      categories = [ "System" ];
    })

    (makeDesktopItem {
      name = "xscpu64";
      exec = "xscpu64";
      comment = "VICE: SCPU64 Emulator";
      desktopName = "VICE: SCPU64 Emulator";
      genericName = "Commodore SCPU64 Emulator";
      categories = [ "System" ];
    })

    (makeDesktopItem {
      name = "xvic";
      exec = "xvic";
      comment = "VICE: VIC-20 Emulator";
      desktopName = "VICE: VIC-20 Emulator";
      genericName = "Commodore VIC-20 Emulator";
      categories = [ "System" ];
    })

    (makeDesktopItem {
      name = "vsid";
      exec = "vsid";
      comment = "VSID: The SID Emulator";
      desktopName = "VSID: The SID Emulator";
      genericName = "SID Emulator";
      categories = [ "System" ];
    })
  ];
in
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

  preBuild = ''
    for i in src/resid src/resid-dtv
    do
      mkdir -pv $i/src
      ln -sv ../../wrap-u-ar.sh $i/src
    done
  '';

  postInstall = ''
    for app in ${toString desktopItems}
    do
        mkdir -p $out/share/applications
        cp $app/share/applications/* $out/share/applications
    done
  '';

  meta = {
    description = "Emulators for a variety of 8-bit Commodore computers";
    homepage = "https://vice-emu.sourceforge.io/";
    license = lib.licenses.gpl2Plus;
    maintainers = [ lib.maintainers.sander ];
    platforms = lib.platforms.linux;
  };
}
