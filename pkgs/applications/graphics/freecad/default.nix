{ fetchsvn, stdenv, cmake, coin3d, xercesc, ode, eigen, qt4, opencascade, gts,
boost, zlib,
python, swig, gfortran, soqt, libf2c, pyqt4 }:

# It builds but fails to install

stdenv.mkDerivation rec {
  name = "freecad-${version}";
  version = "svn-${src.rev}";

  src = fetchsvn {
    url = https://free-cad.svn.sourceforge.net/svnroot/free-cad/trunk;
    rev = "4184";
    sha256 = "26bd8407ce38f070b81ef39145aed093eed3c200d165a605b8169162d66568ce";
  };

  buildInputs = [ cmake coin3d xercesc ode eigen qt4 opencascade gts boost
    zlib python swig gfortran soqt libf2c pyqt ];

  enableParallelBuilding = true;

  # They are used to boost 1.42, and we have newer boost that require
  # this for freecad to build
  NIX_CFLAGS_COMPILE = "-DBOOST_FILESYSTEM_VERSION=2";

  # This will help only x86_64, but will not hurt on others.
  preBuild = ''
    export NIX_LDFLAGS="-L${gfortran.gcc}/lib64 $NIX_LDFLAGS";
  '';

  patches = [ ./cmakeinstall.patch ];

  meta = {
    homepage = http://free-cad.sourceforge.net/;
    license = [ "GPLv2+" "LGPLv2+" ];
    description = "General purpose Open Source 3D CAD/MCAD/CAx/CAE/PLM modeler";
    maintainers = with stdenv.lib.maintainers; [viric];
    platforms = with stdenv.lib.platforms; linux;
  };
}
