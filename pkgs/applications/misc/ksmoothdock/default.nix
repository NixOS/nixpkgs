{ lib
, mkDerivation
, fetchFromGitHub
, cmake
, extra-cmake-modules
, kactivities
, qtbase
}:

mkDerivation rec {
  pname = "KSmoothDock";
  version = "6.3";

  src = fetchFromGitHub {
    owner = "dangvd";
    repo = "ksmoothdock";
    rev = "v${version}";
    sha256 = "sha256-hO7xgjFMFrEhQs3oc2peFTjSVEDsl7Ma/TeVybEZMEk=";
  };

  nativeBuildInputs = [ cmake extra-cmake-modules ];

  buildInputs = [ kactivities qtbase ];

  cmakeDir = "../src";

  meta = with lib; {
    description = "A cool desktop panel for KDE Plasma 5";
    license = licenses.mit;
    homepage = "https://dangvd.github.io/ksmoothdock/";
    maintainers = with maintainers; [ shamilton ];
    platforms = platforms.linux;
  };
}
