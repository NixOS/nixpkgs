{
  lib,
  stdenv,
  fetchurl,
  boost,
  pkg-config,
  cppunit,
  zlib,
  libwpg,
  libwpd,
  librevenge,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libmwaw";
  version = "0.3.22";

  src = fetchurl {
    url = "mirror://sourceforge/libmwaw/libmwaw/libmwaw-${finalAttrs.version}/libmwaw-${finalAttrs.version}.tar.xz";
    sha256 = "sha256-oaOf/Oo/8qenquDCOHfd9JGLVUv4Kw3l186Of2HqjjI=";
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [
    boost
    cppunit
    zlib
    libwpg
    libwpd
    librevenge
  ];
  enableParallelBuilding = true;

  meta = {
    description = "Import library for some old mac text documents";
    license = lib.licenses.mpl20;
    maintainers = with lib.maintainers; [ raskin ];
    platforms = lib.platforms.unix;
  };
})
