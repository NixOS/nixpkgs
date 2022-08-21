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
  pname = "Surelog";
  version = "2022.05.15";

  src = fetchFromGitHub {
    owner = "chipsalliance";
    repo = pname;
    rev = "15d3698ca5c7d45dd95b58c15e76131420cb001c";
    hash = "sha256-dfje9yZ8ZR7x1EUxDUpKNcOWKYTPwPG6T4HzudV59R4=";
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
  '';

  meta = {
    description = "SystemVerilog 2017 Pre-processor, Parser, Elaborator, UHDM Compiler";
    homepage = "https://github.com/chipsalliance/Surelog";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ matthuszagh ];
    platforms = lib.platforms.all;
  };
}
