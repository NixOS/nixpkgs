{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  libzip,
  zlib,
  bzip2,
  xz,
  zstd,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libzippp";
  version = "7.1-1.10.1";

  src = fetchFromGitHub {
    owner = "ctabin";
    repo = "libzippp";
    rev = "libzippp-v${finalAttrs.version}";
    hash = "sha256-ffX4UuDKMgSYwIecmJnj+XLnjsMwUbK6rraOk0z4Ma8=";
  };

  cmakeFlags = [
    "-DBUILD_SHARED_LIBS=ON"
    "-DLIBZIPPP_GNUINSTALLDIRS=ON"
  ];

  strictDeps = true;
  __structuredAttrs = true;

  nativeBuildInputs = [ cmake ];
  buildInputs = [
    libzip
    zlib
    bzip2
    xz
    zstd
  ];

  meta = {
    description = "A C++ wrapper for libzip";
    homepage = "https://github.com/ctabin/libzippp";
    license = lib.licenses.bsd3;
    platforms = lib.platforms.all;
  };
})
