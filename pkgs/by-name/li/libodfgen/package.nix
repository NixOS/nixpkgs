{
  lib,
  stdenv,
  fetchurl,
  pkg-config,
  librevenge,
  libxml2,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libodfgen";
  version = "0.1.8";

  src = fetchurl {
    url = "mirror://sourceforge/project/libwpd/libodfgen/libodfgen-${finalAttrs.version}/libodfgen-${finalAttrs.version}.tar.xz";
    hash = "sha256-VSAAJ/1GYjub3d040nXnRS0bD/iu3crW+a5twl9hBiU=";
  };

  patches = [
    # Fix build with gcc15, based on:
    # https://sourceforge.net/p/libwpd/libodfgen/ci/4da0b148def5b40ee60d4cd79762c0f158d64cc7/
    ./libodfgen-add-include-cstdint-gcc15.patch
  ];

  enableParallelBuilding = true;

  configureFlags = lib.optional finalAttrs.finalPackage.doCheck "--enable-test";

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [
    librevenge
    libxml2
  ];

  doCheck = true;

  checkFlags = [
    "-C"
    "test"
  ];

  checkTarget = "launch_all";

  meta = {
    description = "Base library for generating ODF documents";
    license = lib.licenses.mpl20;
    maintainers = with lib.maintainers; [ raskin ];
    platforms = lib.platforms.unix;
  };
})
