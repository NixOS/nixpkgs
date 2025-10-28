{
  stdenv,
  lib,
  fetchFromGitHub,
  cmake,
}:

stdenv.mkDerivation rec {
  pname = "armips";
  version = "0.11.0";

  src = fetchFromGitHub {
    owner = "Kingcom";
    repo = "armips";
    rev = "v${version}";
    sha256 = "sha256-L+Uxww/WtvDJn1xZqoqA6Pkzq/98sy1qTxZbv6eEjbA=";
  };

  postPatch = ''
    substituteInPlace CMakeLists.txt \
      --replace-fail c++11 c++17 \
      --replace-fail "cmake_minimum_required(VERSION 2.8)" "cmake_minimum_required(VERSION 3.13)" # done by https://github.com/Kingcom/armips/commit/e1ed5bf0f4565250b98b0ddfb9112f15dc8e8e3b upstream, patch not directly compatible
  '';

  nativeBuildInputs = [ cmake ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin
    cp armips $out/bin

    runHook postInstall
  '';

  doCheck = true;

  checkPhase = ''
    runHook preCheck
    ./armipstests ..
    runHook postCheck
  '';

  meta = with lib; {
    homepage = "https://github.com/Kingcom/armips";
    description = "Assembler for various ARM and MIPS platforms";
    mainProgram = "armips";
    license = licenses.mit;
    maintainers = with maintainers; [ marius851000 ];
  };
}
