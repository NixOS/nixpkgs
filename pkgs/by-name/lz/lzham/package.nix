{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
}:

stdenv.mkDerivation {
  pname = "lzham";
  version = "1.1-unstable-2023-05-14";

  src = fetchFromGitHub {
    owner = "richgel999";
    repo = "lzham_codec_devel";
    rev = "d09fc6676a0313c3814457fbc76351a68f653092";
    sha256 = "sha256-zKzz4gEB2dkIIAuDhKGWeV1hn8tCMVILsiQ/gu6aAEE=";
  };

  nativeBuildInputs = [ cmake ];

  cmakeFlags = [
    "-DCMAKE_SKIP_RPATH=ON"
  ];

  installPhase = ''
    cmake --install . --prefix=$out

    mkdir -p $out/bin
    cp lzhamtest/lzhamtest $out/bin/
  '';

  postPatch = ''
    substituteInPlace {./,lzhamcomp/,lzhamdecomp/,lzhamdll/,lzhamtest/}CMakeLists.txt \
      --replace-fail "cmake_minimum_required(VERSION 2.8)" "cmake_minimum_required(VERSION 3.10)"
  '';

  meta = with lib; {
    description = "Lossless data compression codec with LZMA-like ratios but 1.5x-8x faster decompression speed";
    mainProgram = "lzhamtest";
    homepage = "https://github.com/richgel999/lzham_codec";
    license = with licenses; [ mit ];
    platforms = platforms.linux;
  };
}
