{ lib, stdenv, fetchFromGitHub, cmake, eigen, avogadrolibs, molequeue, hdf5
, openbabel, qttools, wrapQtAppsHook
}:

let
  avogadroI18N = fetchFromGitHub {
    owner = "OpenChemistry";
    repo = "avogadro-i18n";
    rev = "3b8a86cc37e988b043d1503d2f11068389b0aca3";
    sha256 = "9wLY7/EJyIZYnlUAMsViCwD5kGc1vCNbk8vUhb90LMQ=";
  };

in stdenv.mkDerivation rec {
  pname = "avogadro2";
  version = "1.97.0";

  src = fetchFromGitHub {
    owner = "OpenChemistry";
    repo = "avogadroapp";
    rev = version;
    hash = "sha256-gZpMgFSPz70QNfd8gH5Jb9RTxQfQalWx33LkgXLEqOQ=";
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

  qtWrapperArgs = [ "--prefix PATH : ${openbabel}/bin" ];

  meta = with lib; {
    description = "Molecule editor and visualizer";
    maintainers = with maintainers; [ sheepforce ];
    homepage = "https://github.com/OpenChemistry/avogadroapp";
    platforms = platforms.mesaPlatforms;
    license = licenses.bsd3;
  };
}
