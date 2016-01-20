{ stdenv, fetchurl, cmake, coin3d, xercesc, ode, eigen, qt4, opencascade, gts
, boost, zlib, python, swig, gfortran, soqt, libf2c, makeWrapper
, matplotlib, pycollada, pyside, pysideTools, pysideShiboken }:

stdenv.mkDerivation rec {
  name = "freecad-${version}";
  version = "0.15";

  src = fetchurl {
    url = https://github.com/FreeCAD/FreeCAD/archive/0.15.tar.gz;
    sha256 = "1vndvywvq86hyhmg629bkn5ag4lk2mg1pl4dq7jvbjvbrczb12fc";
  };

  buildInputs = [ cmake coin3d xercesc ode eigen qt4 opencascade gts boost
    zlib python swig gfortran soqt libf2c makeWrapper matplotlib
    pycollada pyside pysideShiboken pysideTools
  ];

  enableParallelBuilding = true;

  # This should work on both x86_64, and i686 linux
  preBuild = ''
    export NIX_LDFLAGS="-L${gfortran.cc}/lib64 -L${gfortran.cc}/lib $NIX_LDFLAGS";
  '';

  # Their main() removes PYTHONPATH=, and we rely on it.
  preConfigure = ''
    sed '/putenv("PYTHONPATH/d' -i src/Main/MainGui.cpp
  '';

  postInstall = ''
    wrapProgram $out/bin/FreeCAD --prefix PYTHONPATH : $PYTHONPATH \
      --set COIN_GL_NO_CURRENT_CONTEXT_CHECK 1
  '';

  meta = with stdenv.lib; {
    description = "General purpose Open Source 3D CAD/MCAD/CAx/CAE/PLM modeler";
    homepage = http://www.freecadweb.org/;
    license = licenses.lgpl2Plus;
    maintainers = [ maintainers.viric ];
    platforms = platforms.linux;
  };
}
