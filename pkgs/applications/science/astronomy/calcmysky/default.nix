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
  version = "0.4.0";

  src = fetchFromGitHub {
    owner = "10110111";
    repo = "CalcMySky";
    tag = "v${version}";
    hash = "sha256-AuDHLgOS+Cu2xSJQVi8XfrINoh18STP1ox7JElafW3k=";
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

  meta = {
    description = "Simulator of light scattering by planetary atmospheres";
    homepage = "https://github.com/10110111/CalcMySky";
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [ nickcao ];
  };
}
