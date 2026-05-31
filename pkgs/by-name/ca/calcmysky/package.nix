{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  qt6,
  glm,
  eigen,
  stellarium,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "calcmysky";
  version = "0.4.0";

  src = fetchFromGitHub {
    owner = "10110111";
    repo = "CalcMySky";
    tag = "v${finalAttrs.version}";
    hash = "sha256-AuDHLgOS+Cu2xSJQVi8XfrINoh18STP1ox7JElafW3k=";
  };

  nativeBuildInputs = [
    cmake
    qt6.wrapQtAppsHook
  ];
  buildInputs = [
    glm
    eigen
    qt6.qtbase
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
})
