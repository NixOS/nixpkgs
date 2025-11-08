{
  stdenv,
  lib,
  fetchFromGitHub,
  cmake,
  gtest,
  tinycmmc,
}:

stdenv.mkDerivation {
  pname = "sexp-cpp";
  version = "0.1.0-unstable-2025-07-21";

  src = fetchFromGitHub {
    owner = "lispparser";
    repo = "sexp-cpp";
    rev = "677b6f3ecd54e92339d33062084b081ebb9f14a6";
    sha256 = "sha256-/wH9Cgo+4eyYRyUcYRNkYR38rLRv/mJq87dpE9wCPlw=";
  };

  nativeBuildInputs = [ cmake ];
  buildInputs = [
    gtest
    tinycmmc
  ];

  cmakeFlags = [
    "-DBUILD_TESTS=ON"
    "-DUSE_CXX17=ON"
  ];

  doCheck = true;

  postPatch = ''
    substituteInPlace CMakeLists.txt \
      --replace-fail "cmake_minimum_required(VERSION 3.0)" "cmake_minimum_required(VERSION 3.10)"
  '';

  meta = {
    description = "S-Expression parser for C++";
    maintainers = [ lib.maintainers.SchweGELBin ];
    platforms = lib.platforms.linux;
    license = lib.licenses.gpl3;
  };
}
