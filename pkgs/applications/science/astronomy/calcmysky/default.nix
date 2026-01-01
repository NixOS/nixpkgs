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
<<<<<<< HEAD
  version = "0.4.0";
=======
  version = "0.3.5";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "10110111";
    repo = "CalcMySky";
    tag = "v${version}";
<<<<<<< HEAD
    hash = "sha256-AuDHLgOS+Cu2xSJQVi8XfrINoh18STP1ox7JElafW3k=";
=======
    hash = "sha256-++011c4/IFf/5GKmFostTnxgfEdw3/GJf0e5frscCQ4=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
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

<<<<<<< HEAD
  meta = {
    description = "Simulator of light scattering by planetary atmospheres";
    homepage = "https://github.com/10110111/CalcMySky";
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [ nickcao ];
=======
  meta = with lib; {
    description = "Simulator of light scattering by planetary atmospheres";
    homepage = "https://github.com/10110111/CalcMySky";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ nickcao ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
