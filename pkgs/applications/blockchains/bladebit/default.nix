{ lib
, fetchFromGitHub
, stdenv, git
, cmake , numactl, bls-signatures, chia-relic, gmp, libsodium
, substituteAll
}:

stdenv.mkDerivation {
  pname = "bladebit";
  version = "2.0.0-alpha2";

  src = fetchFromGitHub {
    owner = "Chia-Network";
    repo = "bladebit";
    rev = "v2.0.0-alpha2";
    sha256 = "sha256-xEzOmeXvTa6emzlWCs8rgAY8JMxOHeRBqmaOFh2rzGc=";
    fetchSubmodules = true;
  };

  patchFlags = [ "--binary" ];
  patches = [
    # prevent CMake from trying to get libraries on the Internet
    (substituteAll {
        src = ./find_bls.patch;
        inherit gmp;
        gmpdev = gmp.dev;
        bls = bls-signatures;
        relic = chia-relic;
        sodium = libsodium;
      })
  ];

  nativeBuildInputs = [ cmake numactl gmp gmp.dev libsodium chia-relic];

  buildPhase = ''
    cmake . -DBUILD_BLADEBIT_TESTS=false
    cmake --build . --target bladebit --config Release -j10
  '';

  installPhase = ''
    runHook preInstall
    install -D -m 755 bladebit $out/bin/bladebit
    runHook postInstall
  '';

  enableParallelBuilding = true;
  cmakeFlags = [
    "-DBUILD_BLADEBIT_TESTS=false"
  ];

  meta = with lib; {
    homepage = "https://github.com/Chia-Network/bladebit";
    description = "BladeBit - Fast Chia (XCH) k32-only Plotter";
    license = licenses.gpl3Only;
    platforms = platforms.linux;
    maintainers = with maintainers; [ abueide ];
  };
}
