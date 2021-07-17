{ lib, stdenv, fetchFromGitHub, cmake, eigen, avogadrolibs, molequeue, hdf5
, openbabel, qt5, wrapQtAppsHook, makeWrapper
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

  nativeBuildInputs = [ cmake wrapQtAppsHook makeWrapper ];

  buildInputs = [
    avogadrolibs
    molequeue
    eigen
    hdf5
    qt5.qttools
  ];

  propagatedBuildInputs = [ openbabel ];

  postFixup = ''
    wrapProgram $out/bin/avogadro2 \
      --prefix PATH : "${openbabel}/bin"
  '';


  meta = with lib; {
    description = "Molecule editor and visualizer";
    maintainers = with maintainers; [ sheepforce ];
    platforms = platforms.mesaPlatforms;
    license = licenses.bsd3;
  };
}
