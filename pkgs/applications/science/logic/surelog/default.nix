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
  version = "1.40";

  src = fetchFromGitHub {
    owner = "chipsalliance";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-5nhJilFIJJDCnJUEUgyPNtWSQUgWcvM6LDFgFatAl/k=";
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
