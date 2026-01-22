{
  lib,
  stdenv,
  fetchzip,
  pkg-config,
  boost,
  cppunit,
  doxygen,
  icu,
  librevenge,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "libqxp";
  version = "0.0.2";

  src = fetchzip {
    url = "https://dev-www.libreoffice.org/src/libqxp/libqxp-${finalAttrs.version}.tar.xz";
    hash = "sha256-5AcZDdmowFbsl9xJ/CPXAUL5zSNu90HgX3V0V8Pt/Rw=";
  };

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [
    boost
    cppunit
    doxygen
    icu
    librevenge
  ];

  meta = {
    description = "QuarkXPress import library";
    homepage = "https://wiki.documentfoundation.org/DLP/Libraries/libqxp";
    license = lib.licenses.mpl20;
    maintainers = with lib.maintainers; [ arthsmn ];
    platforms = lib.platforms.all;
  };
})
