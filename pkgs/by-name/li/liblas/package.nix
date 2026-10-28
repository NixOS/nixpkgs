{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch,
  boost,
  cmake,
  libgeotiff,
  libtiff,
  laszip_2,
  zlib,
  fixDarwinDylibNames,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "liblas";
  version = "1.8.1-unstable-2025-11-08";

  src = fetchFromGitHub {
    owner = "libLAS";
    repo = "libLAS";
    rev = "0756b73ed41211d1bb8d9b96c6767f2350d8fe2b";
    hash = "sha256-A+Ek3MVw2wcmVSn1qFNLS59rbgTW+Nlzy6NCZIQ+y7I=";
  };

  patches = [
    (fetchpatch {
      name = "fix-gcc15.patch";
      url = "https://gitlab.archlinux.org/archlinux/packaging/packages/liblas/-/raw/1.8.1.r128+gded46373-17/liblas-gcc15.patch";
      hash = "sha256-cOm5ElnR2mK+ofU0F4xzYTkFa3Oq8r/WSm4qo45vkt8=";
    })
  ];

  # Upstream libLAS still uses cmake_minimum_required(VERSION 2.8.11).
  # This is not compatible with CMake 4, because support for CMake < 3.5 has been removed.
  postPatch = ''
    substituteInPlace CMakeLists.txt \
      --replace-fail 'cmake_minimum_required(VERSION 2.8.11)' 'cmake_minimum_required(VERSION 3.10)'
  '';

  nativeBuildInputs = [ cmake ] ++ lib.optional stdenv.hostPlatform.isDarwin fixDarwinDylibNames;

  buildInputs = [
    boost
    libgeotiff
    libtiff
    # libLAS is currently not compatible with LASzip 3,
    # see https://github.com/libLAS/libLAS/issues/144.
    laszip_2
    zlib
  ];

  cmakeFlags = [
    (lib.cmakeBool "WITH_LASZIP" true)
    (lib.cmakeFeature "CMAKE_EXE_LINKER_FLAGS" "-pthread")
  ];

  postFixup = lib.optionalString stdenv.hostPlatform.isDarwin ''
    install_name_tool -change "@rpath/liblas.3.dylib" "$out/lib/liblas.3.dylib" $out/lib/liblas_c.dylib
  '';

  meta = {
    description = "LAS 1.0/1.1/1.2 ASPRS LiDAR data translation toolset";
    homepage = "https://liblas.org";
    license = lib.licenses.bsd3;
    platforms = lib.platforms.unix;
    maintainers = [ ];
    teams = with lib.teams; [ geospatial ];
  };
})
