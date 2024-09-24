{ lib, stdenv
, fetchFromGitHub
, qmake
, wrapQtAppsHook
, boost }:

stdenv.mkDerivation rec {
  pname = "zegrapher";
  version = "3.1.1";

  src = fetchFromGitHub {
    owner = "AdelKS";
    repo = "ZeGrapher";
    rev = "v${version}";
    sha256 = "sha256-OSQXm0gDI1zM2MBM4iiY43dthJcAZJkprklolsNMEvk=";
  };

  nativeBuildInputs = [
    qmake
    wrapQtAppsHook
  ];
  buildInputs = [
    boost
  ];

  meta = with lib; {
    homepage = "https://zegrapher.com/";
    description = "Open source math plotter";
    mainProgram = "ZeGrapher";
    longDescription = ''
      An open source, free and easy to use math plotter. It can plot functions,
      sequences, parametric equations and data on the plane.
    '';
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ AndersonTorres ];
  };
}
