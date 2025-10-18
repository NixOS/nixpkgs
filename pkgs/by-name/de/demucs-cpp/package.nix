{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  blas,
}:
stdenv.mkDerivation rec {
  pname = "demucs-cpp";
  version = "0.0.4-alpha";
  src = fetchFromGitHub {
    fetchSubmodules = true;
    owner = "sevagh";
    repo = "demucs.cpp";
    rev = "v${version}";
    hash = "sha256-STbD2bJnMhcglkNKzExZbteFbmT1lDnfnhJPuV3TgAk=";
  };

  buildInputs = [ blas ];

  nativeBuildInputs = [ cmake ];

  installPhase = ''
    mkdir -p $out/bin
    mv *.cpp.main $out/bin
  '';

  meta = with lib; {
    description = ''
      C++17 port of Demucs v3 (hybrid) and v4 (hybrid transformer) models with ggml and Eigen3.
      The weights are not included and need to be downloaded, as explained here:
      https://github.com/sevagh/demucs.cpp/tree/main?tab=readme-ov-file#download-weights
    '';
    homepage = "https://github.com/sevagh/demucs.cpp";
    license = licenses.mit;
    mainProgram = "demucs_mt.cpp.main";
    maintainers = with maintainers; [ lenny ];
  };
}
