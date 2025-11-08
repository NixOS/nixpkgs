{
  boost,
  cairo,
  cmake,
  cups,
  fetchurl,
  fetchpatch,
  fontconfig,
  freetype,
  graphicsmagick,
  harfbuzzFull,
  hunspell,
  lcms2,
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
  lib,
  stdenv,
  qt6,
}:

let
  pythonEnv = python3.withPackages (ps: [
    ps.pillow
    ps.tkinter
  ]);
in
stdenv.mkDerivation (finalAttrs: {
  pname = "scribus";

  version = "1.7.0";

  src = fetchurl {
    url = "mirror://sourceforge/scribus/scribus-devel/scribus-${finalAttrs.version}.tar.xz";
    hash = "sha256-+lnWIh/3z/qTcjV5l+hlcBYuHhiRNza3F2/RD0jCQ/Y=";
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
    pythonEnv
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
      url = "https://aur.archlinux.org/cgit/aur.git/plain/fix_build_with_qt_6.9.0.patch?h=scribus-unstable";
      hash = "sha256-hzd9XpoVVqbwvZ40QPGBqqWkIFXug/tSojf/Ikc4nn4=";
    })
    (fetchpatch {
      url = "https://aur.archlinux.org/cgit/aur.git/plain/fix_build_with_poppler_25.02.0.patch?h=scribus-unstable";
      hash = "sha256-t9xJA6KGMGAdUFyjI8OlTNilewyMr1FFM7vjHOM15Xg=";
    })
    (fetchpatch {
      name = "fix-build-poppler-25.06.0.patch";
      url = "https://github.com/scribusproject/scribus/commit/8dcf8d777bd85a0741c455961f2de382e3ed47ec.patch";
      hash = "sha256-JBHCgvEJnYrUdtLnFSXTfr1FFin4uUNUnddYwfRbn7k=";
    })
    (fetchpatch {
      name = "fix-build-poppler-25.07.0.patch";
      url = "https://github.com/scribusproject/scribus/commit/ff6c6abfa8683028e548a269dee6a859b6f63335.patch";
      hash = "sha256-N4jve5feehsX5H0RXdxR4ableKL+c/rTyqCwkEf37Dk=";
    })
    (fetchpatch {
      name = "fix-qt6.10-build.patch";
      url = "https://github.com/scribusproject/scribus/commit/13fc4f874354511e05bf91a48703b57b4c489715.patch";
      hash = "sha256-+pbQ77SaTh04QX55wmS6WeuZf3IGe5nq3pmrhk68tb8=";
    })
    (fetchpatch {
      name = "fix-build-poppler-25.09.0.patch";
      url = "https://github.com/scribusproject/scribus/commit/f0cfe30019a514bdaf38b78590451e2c5b9b5420.patch";
      hash = "sha256-ONQ3BzGhouO+0zqYUObuJC3NUCFi1PWq6qoRvuSZJws=";
    })
    (fetchpatch {
      name = "fix-build-poppler-25.10.0.patch";
      url = "https://github.com/scribusproject/scribus/commit/3c1fc34fae1aa26fceb65b6bdf631a7f00b03c3c.patch";
      hash = "sha256-xTwzbT3h4+5hb6Y/sNmzkfDN2LJGOLP1v/WBVsmZXkk=";
    })
  ];

  meta = {
    maintainers = with lib.maintainers; [ arthsmn ];
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
