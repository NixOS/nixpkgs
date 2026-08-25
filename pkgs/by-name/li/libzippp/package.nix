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
  testers,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libzippp";
  version = "7.1-1.10.1";

  src = fetchFromGitHub {
    owner = "ctabin";
    repo = "libzippp";
    tag = "libzippp-v${finalAttrs.version}";
    hash = "sha256-ffX4UuDKMgSYwIecmJnj+XLnjsMwUbK6rraOk0z4Ma8=";
  };

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

  postPatch = ''
    # https://github.com/ctabin/libzippp/issues/243
    substituteInPlace CMakeLists.txt \
      --replace-fail 'VERSION 6.0.0' 'VERSION ${lib.head (lib.splitString "-" finalAttrs.version)}.0'
  '';

  cmakeFlags = [
    "-DBUILD_SHARED_LIBS=ON"
    "-DLIBZIPPP_GNUINSTALLDIRS=ON"
  ];

  passthru = {
    tests.pkg-config = testers.testMetaPkgConfig finalAttrs.finalPackage;
  };

  meta = {
    description = "A C++ wrapper for libzip";
    longDescription = ''
      libzippp is a simple basic C++ wrapper around the libzip library.
      It is meant to be a portable and easy-to-use library for ZIP handling.
    '';
    homepage = finalAttrs.src.meta.homepage;
    license = lib.licenses.bsd3;
    pkgConfigModules = [ "libzippp" ];
    platforms = lib.platforms.all;
  };
})
