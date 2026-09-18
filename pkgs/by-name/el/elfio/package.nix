{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  boost,
  gtest,
  fetchpatch,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "elfio";
  version = "3.12";

  src = fetchFromGitHub {
    owner = "serge1";
    repo = "elfio";
    rev = "Release_${finalAttrs.version}";
    sha256 = "sha256-tDRBscs2L/3gYgLQvb1+8nNxqkr8v1xBkeDXuOqShX4=";
  };

  patches = [
    # Add missing #include <stdint.h> for gcc 15
    (fetchpatch {
      url = "https://github.com/serge1/ELFIO/commit/34d2c64237bb40f09879e7421db120e50e7e2923.patch";
      hash = "sha256-HD+rOwqkuvu4lgeIHhiORNxpuowDfy94i0OgUVqbhJ8=";
    })
    # Replace including of <stdint.h> by <cstdint>
    (fetchpatch {
      url = "https://github.com/serge1/ELFIO/commit/575bfdb12cd90fa8913660295103549f151d116a.patch";
      hash = "sha256-9N/NC5U+zs9eFKYLw/kVdrMGySWakWH7HG4fsK0mvNw=";
    })
  ];

  nativeBuildInputs = [ cmake ];

  nativeCheckInputs = [
    boost
    gtest
  ];

  cmakeFlags = [
    "-DELFIO_BUILD_TESTS=ON"
    "-DFETCHCONTENT_TRY_FIND_PACKAGE_MODE=ALWAYS"
  ];

  doCheck = true;

  meta = {
    description = "Header-only C++ library for reading and generating files in the ELF binary format";
    homepage = "https://github.com/serge1/ELFIO";
    license = lib.licenses.mit;
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ prusnak ];
  };
})
