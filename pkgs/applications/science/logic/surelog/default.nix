{ lib
, stdenv
, fetchFromGitHub
, cmake
, python3
, pkg-config
, libuuid
, openjdk11
, gperftools
}:

stdenv.mkDerivation rec {
  pname = "surelog";
  version = "v1.36";

  src = fetchFromGitHub {
    owner = "chipsalliance";
    repo = pname;
    rev = version;
    hash = "sha256-gMxpnSsJTXmg2VU7mQcw1J40OuqW6oo9/sGplLgV0ho=";
    fetchSubmodules = true;
  };

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
    rm -rf $out/lib/surelog
    rm -rf $out/lib/pkg
  '';

  meta = {
    description = "SystemVerilog 2017 Pre-processor, Parser, Elaborator, UHDM Compiler";
    homepage = "https://github.com/chipsalliance/Surelog";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ matthuszagh ];
    platforms = lib.platforms.all;
  };
}
