{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  wrapQtAppsHook,
  glm,
  eigen,
  qtbase,
  stellarium,
}:

stdenv.mkDerivation rec {
  pname = "calcmysky";
  version = "0.3.2";

  src = fetchFromGitHub {
    owner = "10110111";
    repo = "CalcMySky";
    rev = "refs/tags/v${version}";
    hash = "sha256-AP6YkORbvH8PzF869s2OWbTwTfwMC+RLJx3V3BqVy88=";
  };

  nativeBuildInputs = [
    cmake
    wrapQtAppsHook
  ];
  buildInputs = [
    glm
    eigen
    qtbase
  ];

  cmakeFlags = [ "-DQT_VERSION=6" ];

  doCheck = true;

  passthru.tests = {
    inherit stellarium;
  };

  meta = with lib; {
    description = "Simulator of light scattering by planetary atmospheres";
    homepage = "https://github.com/10110111/CalcMySky";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ nickcao ];
  };
}
