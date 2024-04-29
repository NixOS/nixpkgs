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

  postInstall = ''
    # binaries
    mkdir -p $out/bin
    # main binary that ships with the repo
    cp $out/${pname}-${version} $out/bin/${pname}
    # secondary utility binary shipping with the repo
    cp $out/ConvertInputFormat-${version} $out/bin/ConvertInputFormat

    # libraries
    mkdir -p $out/lib
    # put lib into the right spot so it can actually be found
    cp $out/lib${pname}api.so.${version} $out/lib
  '';

  # this would remove references to libenergyplus from the binaries
  dontPatchELF = true;

  meta = with lib; {
    description = "A whole building energy simulation program to model both energy consumption and water use";
    homepage = "https://github.com/NREL/EnergyPlus";
    license = licenses.energyplus;
    mainProgram = "energyplus";
    maintainers = with maintainers; [ robwalt ];
  };
}
