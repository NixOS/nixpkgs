{
  lib,
  stdenv,
  runCommand,
  fetchzip,
  fetchurl,
  fetchpatch,
  fetchFromGitHub,
  cmake,
  jbig2dec,
  libjpeg_turbo,
  libpng,
  makeWrapper,
  pkg-config,
  zlib,
  enableGSL ? true,
  gsl,
  enableGhostScript ? true,
  ghostscript,
  enableMuPDF ? true,
  mupdf,
  enableDJVU ? true,
  djvulibre,
  enableLeptonica ? true,
  leptonica,
  # Tesseract support is broken
  # See: https://github.com/NixOS/nixpkgs/issues/368349
  # Making GOCR work without Tesseract support is non-trivial
  fetchDebianPatch,
}:

# k2pdfopt requires modified versions of mupdf, leptonica, and tesseract.
# However, Debian just uses system versions with minimal fixes to k2pdfopt's
# willuslib; some fixes to mupdf and leptoanica have since been upstreamed,
# some are not relevant on Linux
# Applying the upstream changes to fresh tesseract with our glibc leads to
# k2pdfopt that crashes on launch, so we can drop tesseract or use the old
# version that k2pdfopt wants

stdenv.mkDerivation (finalAttrs: {
  pname = "k2pdfopt";
  version = "2.55";
  src = fetchzip {
    url = "http://www.willus.com/k2pdfopt/src/k2pdfopt_v${finalAttrs.version}_src.zip";
    hash = "sha256-orQNDXQkkcCtlA8wndss6SiJk4+ImiFCG8XRLEg963k=";
  };

  patches = [
    ./0001-Fix-CMakeLists.patch
    (fetchDebianPatch {
      inherit (finalAttrs) pname;
      version = "${finalAttrs.version}+ds";
      debianRevision = "3.1";
      patch = "0007-k2pdfoptlib-k2ocr.c-conditionally-enable-tesseract-r.patch";
      hash = "sha256-uJ9Gpyq64n/HKqo0hkQ2dnkSLCKNN4DedItPGzHfqR8=";
    })
    (fetchDebianPatch {
      inherit (finalAttrs) pname;
      version = "${finalAttrs.version}+ds";
      debianRevision = "3.1";
      patch = "0009-willuslib-CMakeLists.txt-conditionally-add-source-fi.patch";
      hash = "sha256-cBSlcuhsw4YgAJtBJkKLW6u8tK5gFwWw7pZEJzVMJDE=";
    })
  ];

  postPatch = ''
    substituteInPlace willuslib/bmpdjvu.c \
      --replace-fail "<djvu.h>" "<libdjvu/ddjvuapi.h>"

    # Parts of Debian patches
    substituteInPlace CMakeLists.txt */CMakeLists.txt \
      --replace-fail 'cmake_minimum_required(VERSION 2.6)' \
      'cmake_minimum_required(VERSION 3.31)'
    substituteInPlace willuslib/bmpmupdf.c \
      --replace-fail 'void pdf_install_load_system_font_funcs(fz_context *ctx);' \
      'void pdf_install_load_system_font_funcs(fz_context *ctx) {};'
    substituteInPlace willuslib/wleptonica.c \
      --replace-fail 'dewarpBuildPageModel_ex(dew1,debug,fit_order);' \
      'dewarpBuildPageModel(dew1,debug);'

    # Potential memory corruption under benign use, and cheap to fix
    substituteInPlace willuslib/wfile.c \
      --replace-fail 'char cmd[MAXFILENAMELEN];' \
      'char cmd[4*MAXFILENAMELEN];'
  '';

  nativeBuildInputs = [
    cmake
    pkg-config
    makeWrapper
  ];

  buildInputs = [
    jbig2dec
    libjpeg_turbo
    libpng
    zlib
  ]
  ++ lib.optional enableGSL gsl
  ++ lib.optional enableGhostScript ghostscript
  ++ lib.optional enableMuPDF mupdf
  ++ lib.optional enableDJVU djvulibre
  ++ lib.optional enableLeptonica leptonica;

  cmakeFlags = [ (lib.cmakeFeature "CMAKE_C_FLAGS" "-I${finalAttrs.src}/include_mod") ];

  installPhase = ''
    install -D -m 755 k2pdfopt $out/bin/k2pdfopt
  '';

  meta = {
    description = "Optimizes PDF/DJVU files for mobile e-readers (e.g. the Kindle) and smartphones";
    homepage = "http://www.willus.com/k2pdfopt";
    changelog = "https://www.willus.com/k2pdfopt/k2pdfopt_version.txt";
    license = lib.licenses.gpl3;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [
      raskin
    ];
  };
})
