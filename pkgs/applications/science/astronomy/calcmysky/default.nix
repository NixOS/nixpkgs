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
  version = "0.3.4";

  src = fetchFromGitHub {
    owner = "10110111";
    repo = "CalcMySky";
    tag = "v${version}";
    hash = "sha256-r0F70ouRvUGRo7Zc7BOTe9ujRA5FN+1BdFPDtwIPly4=";
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
