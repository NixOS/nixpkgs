{ lib
, stdenv
, fetchFromGitHub
, cmake
, wrapQtAppsHook
, glm
, eigen
, qtbase
, stellarium
}:

stdenv.mkDerivation rec {
  pname = "calcmysky";
  version = "0.3.1";

  src = fetchFromGitHub {
    owner = "10110111";
    repo = "CalcMySky";
    rev = "refs/tags/v${version}";
    hash = "sha256-oqYOXoIPVqCD3HL7ShNoF89W725hFHX0Ei/yVJNTS5I=";
  };

  nativeBuildInputs = [ cmake wrapQtAppsHook ];
  buildInputs = [ glm eigen qtbase ];

  cmakeFlags = [ "-DQT_VERSION=6" ];

  doCheck = true;

  passthru.tests = {
    inherit stellarium;
  };

  meta = with lib;{
    description = "Simulator of light scattering by planetary atmospheres";
    homepage = "https://github.com/10110111/CalcMySky";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ nickcao ];
  };
}
