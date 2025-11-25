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

stdenv.mkDerivation rec {
  pname = "libodfgen";
  version = "0.1.7";

  src = fetchurl {
    url = "mirror://sourceforge/project/libwpd/libodfgen/libodfgen-${version}/libodfgen-${version}.tar.xz";
    sha256 = "sha256-Mj5JH5VsjKKrsSyZjjUGcJMKMjF7+WYrBhXdSzkiuDE=";
  };

  patches = [
    # Fix build with gcc15, based on:
    # https://sourceforge.net/p/libwpd/libodfgen/ci/4da0b148def5b40ee60d4cd79762c0f158d64cc7/
    ./libodfgen-add-include-cstdint-gcc15.patch
  ];

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [
    boost
    cppunit
    zlib
    libwpg
    libwpd
    librevenge
  ];

  meta = with lib; {
    description = "Base library for generating ODF documents";
    license = licenses.mpl20;
    maintainers = with maintainers; [ raskin ];
    platforms = platforms.unix;
  };
}
