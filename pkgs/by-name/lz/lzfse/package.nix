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
    rev = "88e2d2788b4021d0b2eb9fe2d97352ae9190f128";
    hash = "sha256-pcGnes966TSdYeIwjJv4F7C++cRzuYorb7rvu4030NU=";
  };

  nativeBuildInputs = [ cmake ];

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
    mainProgram = "lzfse";
  };
})
