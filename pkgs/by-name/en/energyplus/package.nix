{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  patchelf,
  python3,
}:
stdenv.mkDerivation rec {
  pname = "energyplus";
  version = "24.1.0";

  src = fetchFromGitHub {
    owner = "NREL";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-g8lWijcZvNkFclSiStU+7HWfm+F8LobP2kIJNV6zczE=";
  };

  nativeBuildInputs = [
    cmake
    python3
  ];

  # this removes references to libenergyplus which are needed.
  # At the time of writing this I don't know how else to solve this
  dontFixup = true;

  meta = with lib; {
    description = "A whole building energy simulation program to model both energy consumption and water use";
    homepage = "https://github.com/NREL/EnergyPlus";
    license = licenses.energyplus;
    mainProgram = "energyplus";
    maintainers = with maintainers; [ robwalt ];
  };
}
