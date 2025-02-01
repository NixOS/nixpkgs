{ lib, stdenv, fetchFromGitHub, nasm, SDL, zlib, libpng, ncurses, libGLU, libGL
, makeDesktopItem }:

let
  desktopItem = makeDesktopItem {
    name = "zsnes";
    exec = "zsnes";
    icon = "zsnes";
    comment = "A SNES emulator";
    desktopName = "zsnes";
    genericName = "zsnes";
    categories = [ "Game" ];
  };

in stdenv.mkDerivation {
  pname = "zsnes";
  version = "1.51";

  src = fetchFromGitHub {
    owner = "emillon";
    repo = "zsnes";
    rev = "fc160b2538738995f600f8405d23a66b070dac02";
    sha256 = "1gy79d5wdaacph0cc1amw7mqm7i0716n6mvav16p1svi26iz193v";
  };

  patches = [
    ./zlib-1.3.patch
    ./fortify3.patch
  ];

  buildInputs = [ nasm SDL zlib libpng ncurses libGLU libGL ];

  prePatch = ''
    for i in $(cat debian/patches/series); do
      echo "applying $i"
      patch -p1 < "debian/patches/$i"
    done
  '';

  # Workaround build failure on -fno-common toolchains:
  #   ld: initc.o:(.bss+0x28): multiple definition of `HacksDisable'; cfg.o:(.bss+0x59e3): first defined here
  # Use pre-c++17 standard (c++17 forbids throw annotations)
  env.NIX_CFLAGS_COMPILE = "-fcommon -std=c++14";

  preConfigure = ''
    cd src
    sed -i "/^STRIP/d" configure
    sed -i "/\$STRIP/d" configure
  '';

  configureFlags = [ "--enable-release" ];

  postInstall = ''
    function installIcon () {
        mkdir -p $out/share/icons/hicolor/$1/apps/
        cp icons/$1x32.png $out/share/icons/hicolor/$1/apps/zsnes.png
    }
    installIcon "16x16"
    installIcon "32x32"
    installIcon "48x48"
    installIcon "64x64"

    mkdir -p $out/share/applications
    ln -s ${desktopItem}/share/applications/* $out/share/applications/
  '';

  meta = {
    description = "A Super Nintendo Entertainment System Emulator";
    license = lib.licenses.gpl2Plus;
    maintainers = [ lib.maintainers.sander ];
    homepage = "https://www.zsnes.com";
    platforms = [ "i686-linux" "x86_64-linux" ];
    mainProgram = "zsnes";
  };
}
