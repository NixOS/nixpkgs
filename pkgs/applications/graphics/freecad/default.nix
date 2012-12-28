{ fetchgit, stdenv, cmake, coin3d, xercesc, ode, eigen, qt4, opencascade, gts,
boost, zlib,
python, swig, gfortran, soqt, libf2c, pyqt4, makeWrapper }:

stdenv.mkDerivation rec {
  name = "freecad-${version}";
  version = "git-20121213";

  src = fetchgit {
    url = git://free-cad.git.sourceforge.net/gitroot/free-cad/free-cad;
    rev = "d3949cedc7e3c924d426660515e06eaf55d1a67f";
    sha256 = "0a07ih0z5d8m69zasmvi7z4lgq0pa67k2g7r1l6nz2d0b30py61w";
  };

  buildInputs = [ cmake coin3d xercesc ode eigen qt4 opencascade gts boost
    zlib python swig gfortran soqt libf2c pyqt4 makeWrapper ];

  enableParallelBuilding = true;

  # This should work on both x86_64, and i686 linux
  preBuild = ''
    export NIX_LDFLAGS="-L${gfortran.gcc}/lib64 -L${gfortran.gcc}/lib $NIX_LDFLAGS";
  '';

  postInstall = ''
    wrapProgram $out/bin/FreeCAD --prefix PYTHONPATH : $PYTHONPATH \
      --set COIN_GL_NO_CURRENT_CONTEXT_CHECK 1
  '';

  patches = [ ./pythonpath.patch ];

  meta = {
    homepage = http://free-cad.sourceforge.net/;
    license = [ "GPLv2+" "LGPLv2+" ];
    description = "General purpose Open Source 3D CAD/MCAD/CAx/CAE/PLM modeler";
    maintainers = with stdenv.lib.maintainers; [viric];
    platforms = with stdenv.lib.platforms; linux;
  };
}
