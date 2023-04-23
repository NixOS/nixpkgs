{ lib
, stdenv
, fetchFromGitHub
, cmake
, wrapQtAppsHook
, glm
, eigen
, qtbase
}:

stdenv.mkDerivation rec {
  pname = "calcmysky";
  version = "0.3.0";

  src = fetchFromGitHub {
    owner = "10110111";
    repo = "CalcMySky";
    rev = "refs/tags/v${version}";
    hash = "sha256-QVKyPyod0pxoFge/GAcle9AWXPCLR/seBVWRfs9I9tE=";
  };

  nativeBuildInputs = [ cmake wrapQtAppsHook ];
  buildInputs = [ glm eigen qtbase ];

  cmakeFlags = [ "-DQT_VERSION=6" ];

  doCheck = true;

  meta = with lib;{
    description = "Simulator of light scattering by planetary atmospheres";
    homepage = "https://github.com/10110111/CalcMySky";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ nickcao ];
  };
}
