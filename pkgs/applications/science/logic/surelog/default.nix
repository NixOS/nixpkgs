{ lib
, stdenv
, fetchFromGitHub
, cmake
, python3
, pkg-config
, libuuid
, openjdk11
, gperftools
, flatbuffers
, fetchpatch
}:

stdenv.mkDerivation rec {
  pname = "surelog";
  version = "1.45";

  src = fetchFromGitHub {
    owner = "chipsalliance";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-/SSKcEIhmWDOKN4v3djWTwZ5/nQvR8ibflzSVFDt/rM=";
    fetchSubmodules = true;
  };

  # This prevents race conditions in unit tests that surface since we run
  # ctest in parallel.
  # This patch can be removed with the next version of surelog
  patches = [
    (fetchpatch {
      url = "https://github.com/chipsalliance/Surelog/commit/9a54efbd156becf65311a4272104810f36041fa6.patch";
      sha256 = "sha256-rU1Z/0wlVTgnPLqTN/87n+gI1iJ+6k/+sunVVd0ulhQ=";
      name = "parallel-test-running.patch";
    })
  ];

  nativeBuildInputs = [
    cmake
    pkg-config
    openjdk11
    (python3.withPackages (p: with p; [
      psutil
      orderedmultidict
    ]))
  ];

  buildInputs = [
    libuuid
    gperftools
    flatbuffers
  ];

  cmakeFlags = [
    "-DSURELOG_USE_HOST_FLATBUFFERS=On"
  ];

  doCheck = true;
  checkPhase = ''
    runHook preCheck
    make -j $NIX_BUILD_CORES UnitTests
    ctest --output-on-failure
    runHook postCheck
  '';

  postInstall = ''
    mv $out/lib/surelog/* $out/lib/
    mv $out/lib/pkg $out/lib/surelog/
  '';

  meta = {
    description = "SystemVerilog 2017 Pre-processor, Parser, Elaborator, UHDM Compiler";
    homepage = "https://github.com/chipsalliance/Surelog";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ matthuszagh ];
    platforms = lib.platforms.linux;
  };
}
