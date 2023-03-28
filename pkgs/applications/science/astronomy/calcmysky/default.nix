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
  version = "unstable-2023-02-11";

  src = fetchFromGitHub {
    owner = "10110111";
    repo = "CalcMySky";
    rev = "c5f281452816d8de775b13a70fb90e79427c93c4";
    hash = "sha256-mzxtu6YTaZpR17m2WGiSDo/bAPXGJdQskyz7aqtxGoQ=";
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
