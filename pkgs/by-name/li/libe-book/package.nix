{
  lib,
  stdenv,
  fetchurl,
  gperf,
  pkg-config,
  librevenge,
  libxml2,
  boost,
  icu,
  cppunit,
  zlib,
  liblangtag,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libe-book";
  version = "0.1.3";

  src = fetchurl {
    url = "mirror://sourceforge/libebook/libe-book-${finalAttrs.version}/libe-book-${finalAttrs.version}.tar.xz";
    hash = "sha256-fo2P808ngxrKO8b5zFMsL5DSBXx3iWO4hP89HjTf4fk=";
  };

  # restore compatibility with icu68+
  # https://sourceforge.net/p/libebook/code/ci/edc7a50a06f56992fe21a80afb4f20fbdc5654ed/
  postPatch = ''
    substituteInPlace src/lib/EBOOKCharsetConverter.cpp --replace-fail \
      "TRUE, TRUE, &status)" \
      "true, true, &status)"
  '';

  nativeBuildInputs = [
    pkg-config
    gperf
  ];

  buildInputs = [
    librevenge
    libxml2
    boost
    icu
    cppunit
    zlib
    liblangtag
  ];

  strictDeps = true;

  enableParallelBuilding = true;

  meta = {
    description = "Library for import of reflowable e-book formats";
    license = lib.licenses.lgpl21Plus;
    maintainers = with lib.maintainers; [ raskin ];
    platforms = lib.platforms.unix;
  };
})
