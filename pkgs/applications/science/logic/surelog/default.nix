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
, capnproto
, nlohmann_json
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "surelog";
  version = "1.76";

  src = fetchFromGitHub {
    owner = "chipsalliance";
    repo = finalAttrs.pname;
    rev = "v${finalAttrs.version}";
    hash = "sha256-Vg9NZrgzFRVIsEbZQe8DItDhFOVG1XZoQWBrLzVNwLU=";
    fetchSubmodules = false;  # we use all dependencies from nix
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
    uhdm
    capnproto
    antlr4.runtime.cpp
    nlohmann_json
  ];

  cmakeFlags = [
    "-DSURELOG_USE_HOST_CAPNP=On"
    "-DSURELOG_USE_HOST_UHDM=On"
    "-DSURELOG_USE_HOST_GTEST=On"
    "-DSURELOG_USE_HOST_ANTLR=On"
    "-DSURELOG_USE_HOST_JSON=On"
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
    mainProgram = "surelog";
    maintainers = with lib.maintainers; [ matthuszagh ];
    platforms = lib.platforms.all;
  };
})
