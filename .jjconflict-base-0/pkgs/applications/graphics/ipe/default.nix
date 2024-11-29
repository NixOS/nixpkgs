{ lib
, stdenv
, makeDesktopItem
, fetchFromGitHub
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
, qtsvg
, texliveSmall
, wrapQtAppsHook
, zlib
, withTeXLive ? true
, buildPackages
}:

stdenv.mkDerivation rec {
  pname = "ipe";
  version = "7.2.30";

  src = fetchFromGitHub {
    owner = "otfried";
    repo = "ipe";
    rev = "refs/tags/v${version}";
    hash = "sha256-bvwEgEP/cinigixJr8e964sm6secSK+7Ul7WFfwM0gE=";
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
    qtsvg
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
    description = "Editor for drawing figures";
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
