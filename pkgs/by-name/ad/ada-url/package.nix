{ lib, fetchFromGitHub, stdenv, cpm-cmake, simdjson, cmake, cxxopts, }:

let
  googletest = fetchFromGitHub {
    owner = "google";
    repo = "googletest";
    rev = "v1.14.0";
    hash = "sha256-t0RchAHTJbuI5YW4uyBPykTvcjy90JW9AOPNjIhwh6U=";
  };
  googlebenchmark = fetchFromGitHub {
    owner = "google";
    repo = "benchmark";
    rev = "v1.6.0";
    hash = "sha256-EAJk3JhLdkuGKRMtspTLejck8doWPd7Z0Lv/Mvf3KFY=";
  };
  pname = "ada-url";
  version = "2.9.0";
in stdenv.mkDerivation {
  inherit pname version;
  src = fetchFromGitHub {
    owner = "ada-url";
    repo = "ada";
    rev = "v${version}";
    hash = "sha256-eh/tOwU+sU/8FYYuRE7DL1v1Fp6bNFWneLtGG0wsWgA=";
  };

  patches = [ ./conditional-dl.patch ];

  preConfigure = ''
    mkdir -p ${placeholder "out"}/share/cpm
    cp ${cpm-cmake}/share/cpm/CPM.cmake ${
      placeholder "out"
    }/share/cpm/CPM_0.38.6.cmake
  '';

  cmakeFlags = [
    "-DCPM_SOURCE_CACHE=${placeholder "out"}/share"
    "-DFETCHCONTENT_SOURCE_DIR_SIMDJSON=${simdjson.src}"
    "-DFETCHCONTENT_SOURCE_DIR_GTEST=${googletest}"
    "-DFETCHCONTENT_SOURCE_DIR_BENCHMARK=${googlebenchmark}"
    "-DBUILD_SHARED_LIBS=ON"
  ];

  nativeBuildInputs = [ cmake ];

  buildInputs = [ cxxopts ];

  meta = with lib; {
    homepage = "https://www.ada-url.com/";
    description = "WHATWG-compliant and fast URL parser written in modern C++";
    license = with licenses; [ asl20 mit ];
    platforms = platforms.all;
    maintainers = with maintainers; [ anonrig ];
  };
}
