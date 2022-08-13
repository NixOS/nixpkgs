{ lib
, fetchFromGitHub
, stdenv
, cmake , numactl, bls-signatures
, substituteAll
}:

stdenv.mkDerivation {
  pname = "bladebit";
  version = "2.0.0-alpha2";

  src = fetchFromGitHub {
    owner = "Chia-Network";
    repo = "bladebit";
    rev = "904003341e78edc7554be13d2d9c91b5aaf03d26";
    sha256 = "sha256-xEzOmeXvTa6emzlWCs8rgAY8JMxOHeRBqmaOFh2rzGc=";
    fetchSubmodules = true;
  };

  patchFlags = [ "--binary" ];
  patches = [
    # prevent CMake from trying to get libraries on the Internet
    ./find_bls.patch
  ];

  nativeBuildInputs = [ cmake numactl ];

  buildInputs = [
    bls-signatures
  ];


  CXXFLAGS = "-O3 -fmax-errors=1";
    cmakeFlags = [
      "-DARITH=easy"
      "-DBUILD_BLS_PYTHON_BINDINGS=false"
      "-DBUILD_BLS_TESTS=false"
      "-DBUILD_BLS_BENCHMARKS=false"
    ];

  installPhase = ''
    runHook preInstall

    install -D -m 755 bladebit $out/bin/bladebit

    runHook postInstall
  '';

  meta = with lib; {
    homepage = "https://github.com/Chia-Network/bladebit";
    description = "BladeBit - Fast Chia (XCH) k32-only Plotter";
    license = licenses.gpl3Only;
    platforms = platforms.linux;
    maintainers = with maintainers; [ abueide ];
  };
}
