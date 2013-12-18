{ stdenv, fetchurl, cmake, coin3d, xercesc, ode, eigen, qt4, opencascade, gts
, boost, zlib, python, swig, gfortran, soqt, libf2c , pyqt4, makeWrapper
, matplotlib, pycollada }:

stdenv.mkDerivation rec {
  name = "freecad-${version}";
  version = "0.13.1830";

  src = fetchurl {
    url = "mirror://sourceforge/free-cad/${name}.tar.gz";
    sha256 = "04rgww5y32asn4sx5j4wh79ggvb479pq56xfcfj6gkg44mid23jm";
  };

  buildInputs = [ cmake coin3d xercesc ode eigen qt4 opencascade gts boost
    zlib python swig gfortran soqt libf2c pyqt4 makeWrapper matplotlib
    pycollada
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

  meta = {
    homepage = http://free-cad.sourceforge.net/;
    license = [ "GPLv2+" "LGPLv2+" ];
    description = "General purpose Open Source 3D CAD/MCAD/CAx/CAE/PLM modeler";
    maintainers = with stdenv.lib.maintainers; [viric];
    platforms = with stdenv.lib.platforms; linux;
  };
}
