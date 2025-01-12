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
