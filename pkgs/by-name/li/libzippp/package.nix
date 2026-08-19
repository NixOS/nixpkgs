{ lib
, stdenv
, fetchFromGitHub
, cmake
, libzip
, zlib
, bzip2
, xz
, zstd
}:

stdenv.mkDerivation rec {
  pname = "libzippp";
  version = "7.1-1.10.1";

  src = fetchFromGitHub {
    owner = "ctabin";
    repo = "libzippp";
    rev = "libzippp-v${version}";
    hash = "sha256-ffX4UuDKMgSYwIecmJnj+XLnjsMwUbK6rraOk0z4Ma8=";
  };

  cmakeFlags = [
    "-DBUILD_SHARED_LIBS=ON"
    "-DLIBZIPPP_GNUINSTALLDIRS=ON"
  ];

  nativeBuildInputs = [ cmake ];
  buildInputs = [ libzip zlib bzip2 xz zstd ];

  meta = with lib; {
    description = "A C++ wrapper for libzip";
    homepage = "https://github.com";
    license = licenses.mit;
    platforms = platforms.all;
  };
}
