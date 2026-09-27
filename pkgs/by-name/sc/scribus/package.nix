{
  boost,
  cairo,
  cmake,
  cups,
  fetchpatch,
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
  podofo,
  poppler,
  poppler_data,
  python3,
  qt6,
  stdenv,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "scribus";

  version = "1.7.3";

  src = fetchurl {
    url = "mirror://sourceforge/scribus/scribus-devel/scribus-${finalAttrs.version}.tar.xz";
    hash = "sha256-iC7lXKRJfALE4F8wrMaJ6h9IXC6AI8nrKT9RwsW+Bq0=";
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
    podofo
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

  patches = [
    (fetchpatch {
      name = "fix-build-with-poppler-26.05.0.patch";
      url = "https://github.com/scribusproject/scribus/commit/14a287fc1db2a44abfe1743260554447b31b4adf.patch";
      hash = "sha256-bhxnyL5zWVCjkfkW67CPykLW/uqDP+n3djnRKGMyhjw=";
    })
    (fetchpatch {
      # required for the next patch to apply cleanly
      url = "https://github.com/scribusproject/scribus/commit/3aed8aa40d01d1affd2b55b107b48878d4b06eab.patch";
      includes = [ "scribus/plugins/import/pdf/importpdf.cpp" ];
      hash = "sha256-tiGXGW8CnG0Tj5YaimngelvNvO3CCSa5eXc3bSKJD54=";
    })
    (fetchpatch {
      name = "fix-build-with-poppler-26.06.0.patch";
      url = "https://github.com/scribusproject/scribus/commit/2b9405a00a96a09e0183190ddc9f83d44963d4e0.patch";
      hash = "sha256-4v+Ba+JODwNg4YLmwpFeBfIxk1j+RcZdtznPFeQ+H+w=";
    })
  ];

  postPatch = ''
    # revert non-whitespace changes made by the second patch, i.e.,
    # https://github.com/scribusproject/scribus/commit/3aed8aa40d01d1affd2b55b107b48878d4b06eab
    substituteInPlace scribus/plugins/import/pdf/importpdf.cpp \
      --replace-fail 'QSizeF()' '"Custom"'
  '';

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
