{ stdenv, fetchurl, cmake, coin3d, xercesc, ode, eigen, qt4, opencascade, gts
, hdf5, vtk, medfile, zlib, python27Packages, swig, gfortran
, soqt, libf2c, makeWrapper
, mpi ? null }:

assert mpi != null;

let
  pythonPackages = python27Packages;
in stdenv.mkDerivation rec {
  name = "freecad-${version}";
  version = "0.18.2";

  src = fetchurl {
    url = "https://github.com/FreeCAD/FreeCAD/archive/${version}.tar.gz";
    sha256 = "1r5rhaiq22yhrfpmcmzx6bflqj6q9asbyjyfja4x4rzfy9yh0a4v";
  };

  buildInputs = [ cmake coin3d xercesc ode eigen qt4 opencascade gts
    zlib  swig gfortran soqt libf2c makeWrapper  mpi vtk hdf5 medfile
  ] ++ (with pythonPackages; [
    matplotlib pycollada pyside pysideShiboken pysideTools pivy python boost
  ]);

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

  postFixup = ''
    mv $out/share/doc $out
  '';
    
  meta = with stdenv.lib; {
    description = "General purpose Open Source 3D CAD/MCAD/CAx/CAE/PLM modeler";
    homepage = https://www.freecadweb.org/;
    license = licenses.lgpl2Plus;
    maintainers = [ maintainers.viric ];
    platforms = platforms.linux;
  };
}
