{
  boost,
  cairo,
  cmake,
  cups,
  fetchurl,
  fontconfig,
  freetype,
  graphicsmagick,
  gsettings-desktop-schemas,
  gtk3,
  harfbuzzFull,
  hunspell,
  lcms2,
  lib,
  libcdr,
  libfreehand,
  libjpeg,
  libjxl,
  libmspub,
  libpagemaker,
  libqxp,
  librevenge,
  libsysprof-capture,
  libtiff,
  libvisio,
  libwpg,
  libxml2,
  libzmf,
  pixman,
  pkg-config,
  podofo_0_10,
  poppler,
  poppler_data,
  python3,
  qt6,
  stdenv,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "scribus";

  version = "1.7.2";

  src = fetchurl {
    url = "mirror://sourceforge/scribus/scribus-devel/scribus-${finalAttrs.version}.tar.xz";
    hash = "sha256-nY4RzGusLNlsVTnvvXGSIv9/cOHBhZcogNn7MFHhONA=";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
    qt6.wrapQtAppsHook
  ];

  buildInputs = [
    boost
    cairo
    cups
    fontconfig
    freetype
    graphicsmagick
    harfbuzzFull
    hunspell
    lcms2
    libcdr
    libfreehand
    libjpeg
    libjxl
    libpagemaker
    libqxp
    librevenge
    libsysprof-capture
    libtiff
    libvisio
    libwpg
    libxml2
    libzmf
    pixman
    podofo_0_10
    poppler
    poppler_data
    (python3.withPackages (
      ps: with ps; [
        pillow
        tkinter
      ]
    ))
    qt6.qt5compat
    qt6.qtbase
    qt6.qtdeclarative
    qt6.qtimageformats
    qt6.qtsvg
    qt6.qttools
  ]
  ++ lib.optionals libmspub.meta.available [ libmspub ];

  cmakeFlags = [ (lib.cmakeBool "WANT_GRAPHICSMAGICK" true) ];

  preFixup = ''
    qtWrapperArgs+=(
      --prefix XDG_DATA_DIRS : "${gsettings-desktop-schemas}/share/gsettings-schemas/${gsettings-desktop-schemas.name}"
      --prefix XDG_DATA_DIRS : "${gtk3}/share/gsettings-schemas/${gtk3.name}"
    )
  '';

  meta = {
    maintainers = [ ];
    description = "Desktop Publishing (DTP) and Layout program";
    mainProgram = "scribus";
    homepage = "https://www.scribus.net";
    # There are a lot of licenses...
    # https://github.com/scribusproject/scribus/blob/20508d69ca4fc7030477db8dee79fd1e012b52d2/COPYING#L15-L19
    license = with lib.licenses; [
      bsd3
      gpl2Plus
      mit
      publicDomain
    ];
    platforms = lib.platforms.all;
    broken = stdenv.hostPlatform.isDarwin;
  };
})
