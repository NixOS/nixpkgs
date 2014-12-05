{ stdenv, fetchurl, cmake, coin3d, xercesc, ode, eigen, qt4, opencascade, gts
, boost, zlib, python, swig, gfortran, soqt, libf2c, makeWrapper
, matplotlib, pycollada, pyside, pysideShiboken }:

stdenv.mkDerivation rec {
  name = "freecad-${version}";
  version = "0.14.3702";

  src = fetchurl {
    url = "mirror://sourceforge/free-cad/${name}.tar.gz";
    sha256 = "1jcx7d3mp2wxkd20qdvr4vlf7h5wb0jgab9dl63sicdz88swy97f";
  };

  buildInputs = [ cmake coin3d xercesc ode eigen qt4 opencascade gts boost
    zlib python swig gfortran soqt libf2c makeWrapper matplotlib
    pycollada pyside pysideShiboken
  ];

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

  meta = with stdenv.lib; {
    description = "General purpose Open Source 3D CAD/MCAD/CAx/CAE/PLM modeler";
    homepage = http://www.freecadweb.org/;
    license = licenses.lgpl2Plus;
    maintainers = [ maintainers.viric ];
    platforms = platforms.linux;
  };
}
