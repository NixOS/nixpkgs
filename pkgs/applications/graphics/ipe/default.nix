{ lib
, stdenv
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
, texliveSmall
, wrapQtAppsHook
, zlib
, withTeXLive ? true
, buildPackages
}:

stdenv.mkDerivation rec {
  pname = "ipe";
  version = "7.2.27";

  src = fetchurl {
    url = "https://github.com/otfried/ipe/releases/download/v${version}/ipe-${version}-src.tar.gz";
    sha256 = "sha256-wx/bZy8kB7dpZsz58BeRGdS1BzbrIoafgEmLyFg7wZU=";
  };

  nativeBuildInputs = [ pkg-config copyDesktopItems wrapQtAppsHook ];

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
    zlib
  ] ++ (lib.optionals withTeXLive [
    texliveSmall
  ]);

  makeFlags = [
    "-C src"
    "IPEPREFIX=${placeholder "out"}"
    "LUA_PACKAGE=lua"
    "MOC=${buildPackages.qt6Packages.qtbase}/libexec/moc"
    "IPE_NO_SPELLCHECK=1" # qtSpell is not yet packaged
  ];

  qtWrapperArgs = lib.optionals withTeXLive [ "--prefix PATH : ${lib.makeBinPath [ texliveSmall ]}" ];

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
