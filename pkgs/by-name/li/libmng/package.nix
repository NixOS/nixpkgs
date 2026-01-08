{
  lib,
  cmake,
  ninja,
  pkg-config,
  stdenv,
  fetchurl,
  zlib,
  libpng,
  libjpeg,
  lcms2,
}:

stdenv.mkDerivation rec {
  pname = "libmng";
  version = "2.0.3";

  src = fetchurl {
    url = "mirror://sourceforge/libmng/${pname}-${version}.tar.xz";
    sha256 = "1lvxnpds0vcf0lil6ia2036ghqlbl740c4d2sz0q5g6l93fjyija";
  };

  outputs = [
    "out"
    "dev"
  ];

  nativeBuildInputs = [
    cmake
    ninja
    pkg-config
  ];

  buildInputs = [
    zlib
    libpng
    libjpeg
    lcms2
  ];

  cmakeFlags = [
    # libmng's CMakeLists uses an old cmake_minimum_required(VERSION ...) which
    # CMake 4 rejects. This opts into a compatible policy floor.
    "-DCMAKE_POLICY_VERSION_MINIMUM=3.5"
    "-DBUILD_SHARED_LIBS=ON"
    "-DBUILD_STATIC_LIBS=OFF"
    "-DCMAKE_DLL_NAME_WITH_SOVERSION=ON"
  ];

  meta = {
    description = "Reference library for reading, displaying, writing and examining Multiple-Image Network Graphics";
    homepage = "http://www.libmng.com";
    license = lib.licenses.zlib;
    maintainers = with lib.maintainers; [ marcweber ];
    platforms = lib.platforms.unix ++ lib.platforms.windows;
  };
}
