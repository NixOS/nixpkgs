{ lib
, stdenv
, fetchFromGitHub
, cmake
, python3
, pkg-config
, libuuid
, openjdk
, gperftools
, gtest
, uhdm
, antlr4
, flatbuffers
, capnproto
}:

stdenv.mkDerivation rec {
  pname = "surelog";
  version = "1.57";

  src = fetchFromGitHub {
    owner = "chipsalliance";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-Gty0OSNG5Nonyw7v2KiKP51LhiugMY7uqI6aJ6as0SQ=";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
    openjdk
    (python3.withPackages (p: with p; [
      psutil
      orderedmultidict
    ]))
    gtest
    antlr4
  ];

  buildInputs = [
    libuuid
    gperftools
    flatbuffers
    uhdm
    capnproto
    antlr4.runtime.cpp
  ];

  cmakeFlags = [
    "-DSURELOG_USE_HOST_FLATBUFFERS=On"
    "-DSURELOG_USE_HOST_UHDM=On"
    "-DSURELOG_USE_HOST_GTEST=On"
    "-DSURELOG_USE_HOST_ANTLR=On"
    "-DANTLR_JAR_LOCATION=${antlr4.jarLocation}"
  ];

  doCheck = true;
  checkPhase = ''
    runHook preCheck
    make -j $NIX_BUILD_CORES UnitTests
    ctest --output-on-failure
    runHook postCheck
  '';

  meta = {
    description = "SystemVerilog 2017 Pre-processor, Parser, Elaborator, UHDM Compiler";
    homepage = "https://github.com/chipsalliance/Surelog";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ matthuszagh ];
    platforms = lib.platforms.all;
  };
}
