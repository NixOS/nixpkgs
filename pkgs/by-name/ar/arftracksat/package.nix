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
  version = "unstable-2026-02-19";

  src = fetchFromGitHub {
    owner = "arf20";
    repo = "arftracksat";
    rev = "a9b86878e2ee6f332dc1df07685b7d20970c2f7e";
    hash = "sha256-guDgy4H0pnQCihYwG7HoKApOlEcDtcaRaj6fRuVdLlc=";
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
    curlpp
    glm
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    freeglut
    libGL
    libGLU
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
