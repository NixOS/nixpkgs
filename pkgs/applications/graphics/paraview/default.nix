{ fetchurl, stdenv, cmake, qt4
, mpich2
, python
, libxml2
, mesa, libXt
, boost, silo
}:

stdenv.mkDerivation rec {
  name = "paraview-5.0.1";
  src = fetchurl {
    url = "http://paraview.org/files/v5.0/ParaView-v5.0.1-source.tar.gz";
    sha256 = "1fsh554x4j09bfihxaxlkyjwrlm9wnq7fs64rfi64h98xj1yrpfa";
  };

  patches = [ ./silo.patch ];
  # [  5%] Generating vtkGLSLShaderLibrary.h
  # ../../../bin/ProcessShader: error while loading shared libraries: libvtksys.so.pv3.10: cannot open shared object file: No such file or directory
  preConfigure = ''
    export NIX_LDFLAGS="$NIX_LDFLAGS -rpath $out/lib/paraview-5.01 -rpath ../../../../../../lib -rpath ../../../../../lib -rpath ../../../../lib -rpath ../../../lib -rpath ../../lib -rpath ../lib -ldl -lz"
  '';
  cmakeFlags = [
    "-DPARAVIEW_USE_MPI:BOOL=ON"
## /nix/store/2qf1qgqkkalmdpfby9pwc1l7knnxy5hn-hdf5-1.8.14/lib/libhdf5_hl.a(H5LT.c.o): In function `H5LT_dtype_to_text':
## (.text+0x2adc): undefined reference to `H5Tget_cset'
#    "-DVTK_USE_SYSTEM_HDF5:BOOL=ON"
    "-DVTK_USE_SYSTEM_LIBXML2:BOOL=ON"
    "-DPARAVIEW_ENABLE_PYTHON:BOOL=ON"
    "-DCMAKE_SKIP_BUILD_RPATH=ON"
    "-DPARAVIEW_INSTALL_DEVELOPMENT_FILES=ON"

    "-DPARAVIEW_DATA_EXCLUDE_FROM_ALL:BOOL=ON"
    "-DBUILD_TESTING=OFF"
    # http://www.paraview.org/Wiki/VisIt_Database_Bridge
    "-DPARAVIEW_USE_VISITBRIDGE:BOOL=ON"
    "-DVISIT_BUILD_READER_Silo:BOOL=ON"
  ];

  # https://bugzilla.redhat.com/show_bug.cgi?id=1138466
  NIX_CFLAGS_COMPILE = "-DGLX_GLXEXT_LEGACY";

  enableParallelBuilding = true;

  buildInputs = [ cmake qt4 mpich2 python libxml2 mesa libXt boost silo ];

  meta = {
    homepage = "http://www.paraview.org/";
    description = "3D Data analysis and visualization application";
    license = stdenv.lib.licenses.free;
    maintainers = with stdenv.lib.maintainers; [viric guibert];
    platforms = with stdenv.lib.platforms; linux;
  };
}
