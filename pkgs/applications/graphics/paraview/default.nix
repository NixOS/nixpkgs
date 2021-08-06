{ boost, cmake, fetchFromGitHub, ffmpeg, qtbase, qtx11extras,
  qttools, qtxmlpatterns, qtsvg, gdal, gfortran, libXt, makeWrapper,
  mkDerivation, ninja, mpi, python3, lib, tbb, libGLU, libGL }:

mkDerivation rec {
  pname = "paraview";
  version = "5.9.1";

  src = fetchFromGitHub {
    owner = "Kitware";
    repo = "ParaView";
    rev = "v${version}";
    sha256 = "0pzic95br0vr785jnpxqmfxcljw3wk7bhm2xy0jfmwm1dh2b7xac";
    fetchSubmodules = true;
  };

  # Find the Qt platform plugin "minimal"
  preConfigure = ''
    export QT_PLUGIN_PATH=${qtbase.bin}/${qtbase.qtPluginPrefix}
  '';

  # During build, binaries are called that rely on freshly built
  # libraries.  These reside in build/lib, and are not found by
  # default.
  preBuild = ''
    export LD_LIBRARY_PATH=$LD_LIBRARY_PATH''${LD_LIBRARY_PATH:+:}$PWD/lib:$PWD/VTK/ThirdParty/vtkm/vtk-m/lib
  '';

  cmakeFlags = [
    "-DCMAKE_BUILD_TYPE=Release"
    "-DPARAVIEW_ENABLE_FFMPEG=ON"
    "-DPARAVIEW_ENABLE_GDAL=ON"
    "-DPARAVIEW_ENABLE_MOTIONFX=ON"
    "-DPARAVIEW_ENABLE_VISITBRIDGE=ON"
    "-DPARAVIEW_ENABLE_XDMF3=ON"
    "-DPARAVIEW_INSTALL_DEVELOPMENT_FILES=ON"
    "-DPARAVIEW_USE_MPI=ON"
    "-DPARAVIEW_USE_PYTHON=ON"
    "-DVTK_SMP_IMPLEMENTATION_TYPE=TBB"
    "-DVTKm_ENABLE_MPI=ON"
    "-DCMAKE_INSTALL_LIBDIR=lib"
    "-DCMAKE_INSTALL_INCLUDEDIR=include"
    "-DCMAKE_INSTALL_BINDIR=bin"
    "-DOpenGL_GL_PREFERENCE=GLVND"
    "-GNinja"
  ];

  nativeBuildInputs = [
    cmake
    makeWrapper
    ninja
    gfortran
  ];

  buildInputs = [
    libGLU libGL
    libXt
    mpi
    tbb
    boost
    ffmpeg
    gdal
    qtbase
    qtx11extras
    qttools
    qtxmlpatterns
    qtsvg
  ];

  propagatedBuildInputs = [
    (python3.withPackages (ps: with ps; [ numpy matplotlib mpi4py ]))
  ];

  meta = with lib; {
    homepage = "https://www.paraview.org/";
    description = "3D Data analysis and visualization application";
    license = licenses.free;
    maintainers = with maintainers; [ guibert ];
    platforms = platforms.linux;
  };
}
