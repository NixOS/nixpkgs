{ fetchurl, stdenv, cmake, qt4
, hdf5
, mpich2
, python
, libxml2
, mesa, libXt
}:

stdenv.mkDerivation rec {
  name = "paraview-5.0.1";
  src = fetchurl {
    url = "http://paraview.org/files/v5.0/ParaView-v5.0.1-source.tar.gz";
    sha256 = "1fsh554x4j09bfihxaxlkyjwrlm9wnq7fs64rfi64h98xj1yrpfa";
  };

  # [  5%] Generating vtkGLSLShaderLibrary.h
  # ../../../bin/ProcessShader: error while loading shared libraries: libvtksys.so.pv3.10: cannot open shared object file: No such file or directory
  preConfigure = ''
    export NIX_LDFLAGS="$NIX_LDFLAGS -rpath $out/lib/paraview-5.01 -rpath ../../../../../../lib -rpath ../../../../../lib -rpath ../../../../lib -rpath ../../../lib -rpath ../../lib -rpath ../lib -ldl -lz"
  '';
  cmakeFlags = [
    "-DPARAVIEW_USE_SYSTEM_HDF5:BOOL=ON"
    "-DVTK_USE_SYSTEM_LIBXML2:BOOL=ON"
    "-DPARAVIEW_ENABLE_PYTHON:BOOL=ON"
#  use -DPARAVIEW_INSTALL_THIRD_PARTY_LIBRARIES:BOOL=OFF \ to fix make install error: http://www.cmake.org/pipermail/paraview/2011-February/020268.html
    "-DPARAVIEW_INSTALL_THIRD_PARTY_LIBRARIES:BOOL=OFF"
    "-DCMAKE_SKIP_BUILD_RPATH=ON"
    "-DVTK_USE_RPATH:BOOL=ON"
    "-DPARAVIEW_INSTALL_DEVELOPMENT=ON"
  ];

  # https://bugzilla.redhat.com/show_bug.cgi?id=1138466
  NIX_CFLAGS_COMPILE = "-DGLX_GLXEXT_LEGACY";

  enableParallelBuilding = true;

  buildInputs = [ cmake qt4 hdf5 mpich2 python libxml2 mesa libXt ];

  meta = {
    homepage = "http://www.paraview.org/";
    description = "3D Data analysis and visualization application";
    license = stdenv.lib.licenses.free;
    maintainers = with stdenv.lib.maintainers; [viric guibert];
    platforms = with stdenv.lib.platforms; linux;
  };
}
