{
  lib,
  stdenv,
  fetchzip,
  fetchpatch,
  perl,
  pkg-config,
  boost,
  cppunit,
  doxygen,
  gperf,
  icu,
  lcms2,
  librevenge,
  zlib,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "libfreehand";
  version = "0.1.2";

  src = fetchzip {
    url = "https://dev-www.libreoffice.org/src/libfreehand/libfreehand-${finalAttrs.version}.tar.xz";
    hash = "sha256-0icEGnTtYveP24FbYjRB7tFW/TquSOszbqZspHAhQ7I=";
  };

  nativeBuildInputs = [
    perl
    pkg-config
  ];

  buildInputs = [
    boost
    cppunit
    doxygen
    gperf
    icu
    lcms2
    librevenge
    zlib
  ];

  configureFlags = [ "--disable-werror" ];

  patches = [
    (fetchpatch {
      url = "https://gitlab.archlinux.org/archlinux/packaging/packages/libfreehand/-/raw/main/libfreehand-0.1.2-icu-fix.patch?ref_type=heads";
      hash = "sha256-SRkcF+FRkFdueLSTOMYWo6+CCl05f0OBP6G5VrXRyCw=";
    })
  ];

  meta = {
    description = "Adobe Freehand import library";
    homepage = "https://wiki.documentfoundation.org/DLP/Libraries/libfreehand";
    license = lib.licenses.mpl20;
    maintainers = with lib.maintainers; [ arthsmn ];
    platforms = lib.platforms.all;
  };
})
