{
  stdenv,
  lib,
  fetchFromGitHub,
  cmake,
  scdoc,
}:

stdenv.mkDerivation rec {
  pname = "pipectl";
  version = "0.5.1";

  src = fetchFromGitHub {
    owner = "Ferdi265";
    repo = "pipectl";
    rev = "v${version}";
    hash = "sha256-pNBw1ukNaqu40qPXnORUGApYpJ/0EAO9Tq5zAbDe33I=";
  };

  nativeBuildInputs = [
    cmake
    scdoc
  ];

  cmakeFlags = [
    "-DINSTALL_DOCUMENTATION=ON"
  ];

  meta = with lib; {
    homepage = "https://github.com/Ferdi265/pipectl";
    license = licenses.gpl3;
    description = "Simple named pipe management utility";
    maintainers = with maintainers; [ synthetica ];
    mainProgram = "pipectl";
  };
}
