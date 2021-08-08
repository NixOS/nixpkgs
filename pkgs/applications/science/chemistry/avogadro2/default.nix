{ lib, stdenv, fetchFromGitHub, cmake, eigen, avogadrolibs, molequeue, hdf5
, openbabel, qttools, wrapQtAppsHook
}:

stdenv.mkDerivation rec {
  pname = "avogadro2";
  version = "1.94.0";

  src = fetchFromGitHub {
    owner = "OpenChemistry";
    repo = "avogadroapp";
    rev = version;
    sha256 = "6RaiX23YUMfTYAuSighcLGGlJtqeydNgi3PWGF77Jp8=";
  };

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
