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

stdenv.mkDerivation rec {
  pname = "libwpg";
  version = "0.3.4";

  src = fetchurl {
    url = "mirror://sourceforge/libwpg/${pname}-${version}.tar.xz";
    hash = "sha256-tV/alEDR4HBjDrJIfYuGl89BLCFKJ8runfac7HwATeM=";
  };

  buildInputs = [
    libwpd
    zlib
    librevenge
    boost
  ];
  nativeBuildInputs = [ pkg-config ];

  meta = with lib; {
    homepage = "https://libwpg.sourceforge.net";
    description = "C++ library to parse WPG";
    license = with licenses; [
      lgpl21
      mpl20
    ];
    platforms = platforms.all;
  };
}
