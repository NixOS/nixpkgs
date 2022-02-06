{ mkDerivation
, lib
, fetchFromGitHub
, makeDesktopItem
, qmake
, qtbase
, libpng
, giflib
, impy
}:

let
  desktopItem = makeDesktopItem {
    name = "EvilPixie";
    desktopName = "EvilPixie";
    exec = "evilpixie %F";
    icon = "evilpixie";
    genericName = "Image Editor";
    categories = "Graphics;2DGraphics;RasterGraphics;";
    mimeType = "image/bmp;image/gif;image/jpeg;image/jpg;image/png;image/x-pcx;image/x-targa;image/x-tga;";
  };

in mkDerivation rec {
  pname = "evilpixie";
  version = "0.2.1";

  src = fetchFromGitHub {
    owner = "bcampbell";
    repo = "evilpixie";
    rev = "v${version}";
    sha256 = "0dwgfr8kmkfppgf5wx9i5f7fjz3gxk0ji1l06x1z4r3vj52hdbph";
  };

  nativeBuildInputs = [
    qmake
  ];

  buildInputs = [
    qtbase
    libpng
    giflib
    impy
  ];

  postInstall = ''
    ln -s ${desktopItem}/share/applications $out/share
    install -Dm 444 icon_128x128.png $out/share/icons/hicolor/128x128/apps/evilpixie.png
  '';

  meta = with lib; {
    description = "Pixel-oriented paint program, modelled on Deluxe Paint";
    homepage = "https://github.com/bcampbell/evilpixie"; # http://evilpixie.scumways.com/ is gone
    downloadPage = "https://github.com/bcampbell/evilpixie/releases";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ fgaz ];
    platforms = platforms.all;
  };
}

