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
  version = "0.0.3";

  src = fetchzip {
    url = "https://dev-www.libreoffice.org/src/libqxp/libqxp-${finalAttrs.version}.tar.xz";
    hash = "sha256-cdf9URJUXANhTIbpmeBycaicmNb6YS4sOZc2u1lshUc=";
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
    maintainers = [ ];
    platforms = lib.platforms.all;
    hasNoMaintainersButDependents = true;
  };
})
