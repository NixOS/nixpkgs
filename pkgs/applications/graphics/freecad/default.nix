{ fetchsvn, stdenv, cmake, coin3d, xercesc, ode, eigen, qt4, opencascade, gts,
boost, zlib,
python, swig, gfortran, soqt, libf2c, pyqt4, makeWrapper }:

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
    zlib python swig gfortran soqt libf2c pyqt4 makeWrapper ];

  enableParallelBuilding = true;

  # The freecad people are used to boost 1.42, and we have newer boost that
  # require the -DBOOST_FILESYSTEM_VERSION=2 for freecad to build
  # For zlib to build in i686-linux, as g++ plus glibc defines _LARGEFILE64_SOURCE,
  # we need the -D-FILE_OFFSET_BITS=64 indication for zlib headers to work.
  NIX_CFLAGS_COMPILE = "-DBOOST_FILESYSTEM_VERSION=2 -D_FILE_OFFSET_BITS=64";

  # This should work on both x86_64, and i686 linux
  preBuild = ''
    export NIX_LDFLAGS="-L${gfortran.gcc}/lib64 -L${gfortran.gcc}/lib $NIX_LDFLAGS";
  '';

  postInstall = ''
    wrapProgram $out/bin/FreeCAD --prefix PYTHONPATH : $PYTHONPATH \
      --set COIN_GL_NO_CURRENT_CONTEXT_CHECK 1
  '';

  patches = [ ./cmakeinstall.patch ./pythonpath.patch ];

  meta = {
    homepage = http://free-cad.sourceforge.net/;
    license = [ "GPLv2+" "LGPLv2+" ];
    description = "General purpose Open Source 3D CAD/MCAD/CAx/CAE/PLM modeler";
    maintainers = with stdenv.lib.maintainers; [viric];
    platforms = with stdenv.lib.platforms; linux;
  };
}
