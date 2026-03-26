{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  zlib,
  libpng,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libharu";
  version = "2.4.6";

  src = fetchFromGitHub {
    owner = "libharu";
    repo = "libharu";
    rev = "v${finalAttrs.version}";
    hash = "sha256-Uy16fOZgGC7z8eUtQ6Y0R0B9vXEJcSnyBGQQamkDkik=";
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
    maintainers = [ ];
    platforms = lib.platforms.unix;
  };
})
