{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  zlib,
  libpng,
}:

stdenv.mkDerivation rec {
  pname = "libharu";
  version = "2.4.5";

  src = fetchFromGitHub {
    owner = "libharu";
    repo = "libharu";
    rev = "v${version}";
    hash = "sha256-v2vudB95OdYPiLxS9Al5lsAInsvmharhPWdnUmCl+Bs=";
  };

  nativeBuildInputs = [ cmake ];
  buildInputs = [
    zlib
    libpng
  ];

  meta = {
    description = "Cross platform, open source library for generating PDF files";
    homepage = "http://libharu.org/";
    license = lib.licenses.zlib;
    maintainers = [ lib.maintainers.marcweber ];
    platforms = lib.platforms.unix;
  };
}
