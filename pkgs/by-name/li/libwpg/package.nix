{
  lib,
  stdenv,
  fetchurl,
  pkg-config,
  libwpd,
  zlib,
  librevenge,
  boost,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libwpg";
  version = "0.3.4";

  src = fetchurl {
    url = "mirror://sourceforge/libwpg/libwpg-${finalAttrs.version}.tar.xz";
    hash = "sha256-tV/alEDR4HBjDrJIfYuGl89BLCFKJ8runfac7HwATeM=";
  };

  buildInputs = [
    libwpd
    zlib
    librevenge
    boost
  ];
  nativeBuildInputs = [ pkg-config ];

  meta = {
    homepage = "https://libwpg.sourceforge.net";
    description = "C++ library to parse WPG";
    license = with lib.licenses; [
      lgpl21
      mpl20
    ];
    platforms = lib.platforms.all;
  };
})
