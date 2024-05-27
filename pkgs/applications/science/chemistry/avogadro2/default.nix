{ lib, stdenv, fetchFromGitHub, cmake, eigen, avogadrolibs, molequeue, hdf5
, openbabel, qttools, wrapQtAppsHook
}:

let
  avogadroI18N = fetchFromGitHub {
    owner = "OpenChemistry";
    repo = "avogadro-i18n";
    rev = "7eef0b83ded6221a3ddb85c0118cc26f9a35375c";
    hash = "sha256-AR/y70zeYR9xBzWDB5JXjJdDM+NLOX6yxCQte2lYN/U=";
  };

in stdenv.mkDerivation rec {
  pname = "avogadro2";
  version = "1.99.0";

  src = fetchFromGitHub {
    owner = "OpenChemistry";
    repo = "avogadroapp";
    rev = version;
    hash = "sha256-m8kX4WzOmPE/BZQRePOoUAdMPdWb6pmcqtPvDdEIIao=";
  };

  postUnpack = ''
    cp -r ${avogadroI18N} avogadro-i18n
  '';

  nativeBuildInputs = [ cmake wrapQtAppsHook ];

  buildInputs = [
    avogadrolibs
    molequeue
    eigen
    hdf5
    qttools
  ];

  propagatedBuildInputs = [ openbabel ];

  qtWrapperArgs = [ "--prefix PATH : ${lib.getBin openbabel}/bin" ];

  meta = with lib; {
    description = "Molecule editor and visualizer";
    mainProgram = "avogadro2";
    maintainers = with maintainers; [ sheepforce ];
    homepage = "https://github.com/OpenChemistry/avogadroapp";
    platforms = platforms.mesaPlatforms;
    license = licenses.bsd3;
  };
}
