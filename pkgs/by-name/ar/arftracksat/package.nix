{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  curl,
  nlohmann_json,
  freeglut,
  libGL,
  libGLU,
  curlpp,
  glm,
}:

stdenv.mkDerivation {
  pname = "arftracksat";
  version = "unstable-2025-09-15";

  src = fetchFromGitHub {
    owner = "arf20";
    repo = "arftracksat";
    rev = "5c9b3866b6fcd95382ff56c68cdd38f3d08c1372";
    hash = "sha256-inCgsxrJkBNGmdGPd28XnOJYCiatL35TxDcfvZjA2cY=";
  };

  nativeBuildInputs = [
    cmake
  ];

  postPatch = ''
    substituteInPlace src/main.cpp --replace-fail '/usr/local' "$out"
    substituteInPlace config.json --replace-fail '/usr/local' "$out"
  '';

  buildInputs = [
    curl
    nlohmann_json
    freeglut
    libGL
    libGLU
    curlpp
    glm
  ];

  meta = {
    description = "Satellite tracking software for linux";
    homepage = "https://github.com/arf20/arftracksat";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ matthewcroughan ];
    mainProgram = "arftracksat";
    platforms = lib.platforms.all;
  };
}
