{
  lib,
  stdenv,
  makeDesktopItem,
  fetchFromGitHub,
  fetchpatch,
  pkg-config,
  copyDesktopItems,
  cairo,
  freetype,
  ghostscriptX,
  gsl,
  libjpeg,
  libpng,
  libspiro,
  lua5_5,
  qt6Packages,
  texliveSmall,
  qhull,
  zlib,
  withTeXLive ? true,
  withQVoronoi ? false,
  buildPackages,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "ipe";
  version = "7.2.30";

  src = fetchFromGitHub {
    owner = "otfried";
    repo = "ipe";
    tag = "v${finalAttrs.version}";
    hash = "sha256-bvwEgEP/cinigixJr8e964sm6secSK+7Ul7WFfwM0gE=";
  };

  patches = [
    (fetchpatch {
      name = "fix-gcc16-missing-include.patch";
      url = "https://salsa.debian.org/science-team/ipe/-/raw/e6dc9db1e2d889e86bfa21a95775e778f82ae802/debian/patches/0002-include-stding.patch";
      hash = "sha256-E5F7+qL0ZFTkfixO2+yIhNvKZKW0kltkHDfN+EcB/w8=";
    })
    # Backport of https://github.com/otfried/ipe/commit/4c4f13ddd70f4c1d56470a455df596b9c59ae8fd,
    # extended to update-styles.lua
    ./lua55-for-loop-variables.patch
  ];

  nativeBuildInputs = [
    pkg-config
    copyDesktopItems
    qt6Packages.wrapQtAppsHook
  ];

  buildInputs = [
    cairo
    freetype
    ghostscriptX
    gsl
    libjpeg
    libpng
    libspiro
    lua5_5
  ]
  ++ (with qt6Packages; [
    qtbase
    qtsvg
    zlib
  ])
  ++ (lib.optionals withTeXLive [
    texliveSmall
  ])
  ++ (lib.optionals withQVoronoi [
    qhull
  ]);

  makeFlags = [
    "-C src"
    "IPEPREFIX=${placeholder "out"}"
    "LUA_PACKAGE=lua"
    "MOC=${buildPackages.qt6Packages.qtbase}/libexec/moc"
    "IPE_NO_SPELLCHECK=1" # qtSpell is not yet packaged
  ]
  ++ (lib.optionals withQVoronoi [
    "IPEQVORONOI=1"
    "QHULL_CFLAGS=-I${qhull}/include/libqhull_r"
  ]);

  qtWrapperArgs = lib.optionals withTeXLive [ "--prefix PATH : ${lib.makeBinPath [ texliveSmall ]}" ];

  enableParallelBuilding = true;

  desktopItems = [
    (makeDesktopItem {
      name = "ipe";
      desktopName = "Ipe";
      genericName = "Drawing editor";
      comment = "A drawing editor for creating figures in PDF format";
      exec = "ipe";
      icon = "ipe";
      mimeTypes = [
        "text/xml"
        "application/pdf"
      ];
      categories = [
        "Graphics"
        "Qt"
      ];
      startupNotify = true;
      startupWMClass = "ipe";
    })
  ];

  postInstall = ''
    mkdir -p $out/share/icons/hicolor/128x128/apps
    ln -s $out/share/ipe/${finalAttrs.version}/icons/icon_128x128.png $out/share/icons/hicolor/128x128/apps/ipe.png
  '';

  meta = {
    description = "Editor for drawing figures";
    homepage = "http://ipe.otfried.org"; # https not available
    license = lib.licenses.gpl3Plus;
    longDescription = ''
      Ipe is an extensible drawing editor for creating figures in PDF and Postscript format.
      It supports making small figures for inclusion into LaTeX-documents
      as well as presentations in PDF.
    '';
    maintainers = [ ];
    platforms = lib.platforms.linux;
  };
})
