{ stdenv, lib, cmake, fetchFromGitHub
, wrapQtAppsHook, qtbase, qtquickcontrols2, qtgraphicaleffects
}:

stdenv.mkDerivation rec {
  pname = "graphia";
  version = "2.2";

  src = fetchFromGitHub {
    owner = "graphia-app";
    repo = "graphia";
    rev = version;
    sha256 = "sha256:05givvvg743sawqy2vhljkfgn5v1s907sflsnsv11ddx6x51na1w";
  };

  nativeBuildInputs = [
    cmake
    wrapQtAppsHook
  ];
  buildInputs = [
    qtbase
    qtquickcontrols2
    qtgraphicaleffects
  ];

  meta = with lib; {
    description = "A visualisation tool for the creation and analysis of graphs.";
    homepage = "https://graphia.app";
    license = licenses.gpl3Only;
    maintainers = [ maintainers.bgamari ];
    platforms = platforms.all;
    broken = stdenv.isDarwin; # never built on Hydra https://hydra.nixos.org/job/nixpkgs/trunk/graphia.x86_64-darwin
  };
}
