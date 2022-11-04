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
  version = "0.1.0";

  src = fetchFromGitHub {
    owner = "10110111";
    repo = "CalcMySky";
    rev = "v${version}";
    hash = "sha256-0tHxHek4wqJKLl54zF7wDYN+UPL2y35/YAb6Dtg4k48=";
  };

  nativeBuildInputs = [ cmake wrapQtAppsHook ];
  buildInputs = [ glm eigen qtbase ];

  doCheck = true;

  meta = with lib;{
    description = "Simulator of light scattering by planetary atmospheres";
    homepage = "https://github.com/10110111/CalcMySky";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ nickcao ];
  };
}
