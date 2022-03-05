{ lib
, mkDerivation
, makeDesktopItem
, fetchurl
, pkg-config
, copyDesktopItems
, cairo
, freetype
, ghostscript
, gsl
, libjpeg
, libpng
, libspiro
, lua5
, qtbase
, texlive
, zlib
}:

mkDerivation rec {
  pname = "ipe";
  version = "7.2.23";

  src = fetchurl {
    url = "https://dl.bintray.com/otfried/generic/ipe/7.2/${pname}-${version}-src.tar.gz";
    sha256 = "0yvm3zfba1ljyy518vjnvwpyg7lgnmdwm19v5k0wfgz64aca56x1";
  };

  sourceRoot = "${pname}-${version}/src";

  nativeBuildInputs = [ pkg-config copyDesktopItems ];

  buildInputs = [
    cairo
    freetype
    ghostscript
    gsl
    libjpeg
    libpng
    libspiro
    lua5
    qtbase
    texlive
    zlib
  ];

  IPEPREFIX = placeholder "out";
  URWFONTDIR = "${texlive}/texmf-dist/fonts/type1/urw/";
  LUA_PACKAGE = "lua";

  qtWrapperArgs = [ "--prefix PATH : ${lib.makeBinPath [ texlive ]}" ];

  enableParallelBuilding = true;

  desktopItems = [
    (makeDesktopItem {
      name = pname;
      desktopName = "Ipe";
      genericName = "Drawing editor";
      comment = "A drawing editor for creating figures in PDF format";
      exec = "ipe";
      icon = "ipe";
      mimeTypes = [ "text/xml" "application/pdf" ];
      categories = [ "Graphics" "Qt" ];
      startupNotify = true;
      startupWMClass = "ipe";
    })
  ];

  postInstall = ''
    mkdir -p $out/share/icons/hicolor/128x128/apps
    ln -s $out/share/ipe/${version}/icons/icon_128x128.png $out/share/icons/hicolor/128x128/apps/ipe.png
  '';

  meta = with lib; {
    description = "An editor for drawing figures";
    homepage = "http://ipe.otfried.org"; # https not available
    license = licenses.gpl3Plus;
    longDescription = ''
      Ipe is an extensible drawing editor for creating figures in PDF and Postscript format.
      It supports making small figures for inclusion into LaTeX-documents
      as well as presentations in PDF.
    '';
    maintainers = with maintainers; [ ttuegel ];
    platforms = platforms.linux;
  };
}
