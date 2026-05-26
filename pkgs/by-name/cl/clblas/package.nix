{
  lib,
  stdenv,
  llvmPackages_19,
  fetchFromGitHub,
  fetchpatch,
  cmake,
  gfortran,
  blas,
  boost,
  python3,
  ocl-icd,
  opencl-headers,
}:

let
  stdenv' = if stdenv.hostPlatform.isDarwin then llvmPackages_19.stdenv else stdenv;
in

stdenv'.mkDerivation (finalAttrs: {
  pname = "clblas";
  version = "2.12";

  src = fetchFromGitHub {
    owner = "clMathLibraries";
    repo = "clBLAS";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Wq5oBl3TW3qpK0cyNWVgJMS5/s8xY1dulqDCkkX5lZQ=";
  };

  patches = [
    ./platform.patch
    (fetchpatch {
      url = "https://github.com/clMathLibraries/clBLAS/commit/68ce5f0b824d7cf9d71b09bb235cf219defcc7b4.patch";
      hash = "sha256-XoVcHgJ0kTPysZbM83mUX4/lvXVHKbl7s2Q8WWiUnMs=";
    })
  ];

  postPatch = ''
    sed -i -re 's/(set\(\s*Boost_USE_STATIC_LIBS\s+).*/\1OFF\ \)/g' src/CMakeLists.txt

    substituteInPlace src/CMakeLists.txt \
      --replace-fail "cmake_minimum_required(VERSION 2.8)" "cmake_minimum_required(VERSION 3.10)"
    substituteInPlace src/library/tools/tplgen/CMakeLists.txt \
      --replace-fail "cmake_minimum_required(VERSION 2.6)" "cmake_minimum_required(VERSION 3.10)"
  '';

  preConfigure = ''
    cd src
  '';

  cmakeFlags = [
    "-DBUILD_TEST=OFF"
  ];

  nativeBuildInputs = [
    cmake
    gfortran
    python3
  ];
  buildInputs = [
    blas
    boost
  ]
  ++ lib.optionals (!stdenv.hostPlatform.isDarwin) [
    ocl-icd
    opencl-headers
  ];

  strictDeps = true;

  meta = {
    homepage = "https://github.com/clMathLibraries/clBLAS";
    description = "Software library containing BLAS functions written in OpenCL";
    longDescription = ''
      This package contains a library of BLAS functions on top of OpenCL.
    '';
    license = lib.licenses.asl20;
    maintainers = [ ];
    platforms = lib.platforms.unix;
  };

})
