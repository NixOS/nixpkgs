{ fetchurl, stdenv, cmake, qt4
, hdf5
, mpich2
, python
, libxml2
, mesa
}:

stdenv.mkDerivation rec {
  name = "paraview-3.12.0";
  src = fetchurl {
    url = "http://www.paraview.org/files/v3.12/ParaView-3.12.0.tar.gz";
    sha256 = "0n0n0hrv02rd9rb63z4baalf40m8v870027mr47b93scgp18qyim";
  };

  # [  5%] Generating vtkGLSLShaderLibrary.h
  # ../../../bin/ProcessShader: error while loading shared libraries: libvtksys.so.pv3.10: cannot open shared object file: No such file or directory
  preConfigure = ''
    export NIX_LDFLAGS="$NIX_LDFLAGS -rpath $out/lib/paraview-3.10 -rpath ../../../bin -rpath ../../bin"
  '';
  cmakeFlags = [
#    "-DPARAVIEW_USE_MPI:BOOL=ON"
    "-DPARAVIEW_USE_SYSTEM_HDF5:BOOL=ON"
    "-DVTK_USE_SYSTEM_LIBXML2:BOOL=ON"
    "-DPARAVIEW_ENABLE_PYTHON:BOOL=ON"
#  use -DPARAVIEW_INSTALL_THIRD_PARTY_LIBRARIES:BOOL=OFF \ to fix make install error: http://www.cmake.org/pipermail/paraview/2011-February/020268.html
    "-DPARAVIEW_INSTALL_THIRD_PARTY_LIBRARIES:BOOL=OFF"
    "-DCMAKE_SKIP_BUILD_RPATH=ON"
    "-DVTK_USE_RPATH:BOOL=ON"
    "-DPARAVIEW_INSTALL_DEVELOPMENT=ON"
#    "-DPYTHON_INCLUDE_DIR=${python}/include"
#    "-DPYTHON_LIBRARY="
  ];

  enableParallelBuilding = true;

  buildInputs = [ cmake qt4 hdf5 mpich2 python libxml2 mesa ];

  meta = {
    homepage = "http://www.paraview.org/";
    description = "3D Data analysis and visualization application";
    license = "free";
    maintainers = with stdenv.lib.maintainers; [viric];
    platforms = with stdenv.lib.platforms; linux;
  };
}

