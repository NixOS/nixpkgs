{
  cmake,
  fetchFromGitHub,
  lib,
  stdenv,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "lzfse";
  version = "1.0";

  src = fetchFromGitHub {
    owner = "lzfse";
    repo = "lzfse";
    rev = "lzfse-${finalAttrs.version}";
    hash = "sha256-pcGnes966TSdYeIwjJv4F7C++cRzuYorb7rvu4030NU=";
  };

  nativeBuildInputs = [ cmake ];

  # Fix the build with CMake 4.
  postPatch = ''
    substituteInPlace CMakeLists.txt \
      --replace-fail \
        'cmake_minimum_required(VERSION 2.8.6)' \
        'cmake_minimum_required(VERSION 3.10)'
  '';

  meta = {
    homepage = "https://github.com/lzfse/lzfse";
    description = "Reference C implementation of the LZFSE compressor";
    longDescription = ''
      This is a reference C implementation of the LZFSE compressor introduced in the Compression library with OS X 10.11 and iOS 9.
      LZFSE is a Lempel-Ziv style data compression algorithm using Finite State Entropy coding.
      It targets similar compression rates at higher compression and decompression speed compared to deflate using zlib.
    '';
    platforms = lib.platforms.unix;
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ KSJ2000 ];
    mainProgram = "lzfse";
  };
})
