{ lib
, stdenv
, fetchFromGitHub
, cmake
, wrapQtAppsHook
, glm
, eigen
, qtbase
<<<<<<< HEAD
, stellarium
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
}:

stdenv.mkDerivation rec {
  pname = "calcmysky";
<<<<<<< HEAD
  version = "0.3.1";
=======
  version = "0.3.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "10110111";
    repo = "CalcMySky";
    rev = "refs/tags/v${version}";
<<<<<<< HEAD
    hash = "sha256-oqYOXoIPVqCD3HL7ShNoF89W725hFHX0Ei/yVJNTS5I=";
=======
    hash = "sha256-QVKyPyod0pxoFge/GAcle9AWXPCLR/seBVWRfs9I9tE=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  nativeBuildInputs = [ cmake wrapQtAppsHook ];
  buildInputs = [ glm eigen qtbase ];

  cmakeFlags = [ "-DQT_VERSION=6" ];

  doCheck = true;

<<<<<<< HEAD
  passthru.tests = {
    inherit stellarium;
  };

=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  meta = with lib;{
    description = "Simulator of light scattering by planetary atmospheres";
    homepage = "https://github.com/10110111/CalcMySky";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ nickcao ];
  };
}
