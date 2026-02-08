{
  stdenv,
  lib,
  fetchFromGitHub,
  cmake,
  scdoc,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "pipectl";
  version = "0.5.1";

  src = fetchFromGitHub {
    owner = "Ferdi265";
    repo = "pipectl";
    rev = "v${finalAttrs.version}";
    hash = "sha256-pNBw1ukNaqu40qPXnORUGApYpJ/0EAO9Tq5zAbDe33I=";
  };

  nativeBuildInputs = [
    cmake
    scdoc
  ];

  cmakeFlags = [
    "-DINSTALL_DOCUMENTATION=ON"
  ];

  meta = {
    homepage = "https://github.com/Ferdi265/pipectl";
    license = lib.licenses.gpl3;
    description = "Simple named pipe management utility";
    maintainers = with lib.maintainers; [ synthetica ];
    mainProgram = "pipectl";
  };
})
