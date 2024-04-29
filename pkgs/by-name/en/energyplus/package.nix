{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
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

  buildInputs = [
    cmake
    python3
  ];

  installPhase = ''
    mkdir -p $out
    export SRC=$(pwd)

    cd $out
    cmake $SRC

    cd $SRC
    make -j 32

    mkdir -p $out/lib
    cp -R $SRC/Products/* $out/lib

    mkdir -p $out/bin
    cp $out/lib/"${pname}-${version}" $out/bin/energyplus
  '';

  # It might be desirable to do the fixup. According to the error message this would probably involve ${removeReferencesTo}/bin/remove-references-to ?
  dontFixup = true;

  meta = with lib; {
    description = "A whole building energy simulation program to model both energy consumption and water use";
    homepage = "https://github.com/NREL/EnergyPlus";
    license = licenses.energyplus;
    mainProgram = "energyplus";
    maintainers = with maintainers; [ robwalt ];
  };
}
