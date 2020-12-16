{ boost, cmake, fetchFromGitHub, ffmpeg, qtbase, qtx11extras,
  qttools, qtxmlpatterns, qtsvg, gdal, gfortran, libXt, makeWrapper,
  mkDerivation, ninja, openmpi, python3, stdenv, tbb, libGLU, libGL }:

mkDerivation rec {
  pname = "paraview";
  version = "5.8.0";

  src = fetchFromGitHub {
    owner = "Kitware";
    repo = "ParaView";
    rev = "v${version}";
    sha256 = "1mka6wwg9mbkqi3phs29mvxq6qbc44sspbm4awwamqhilh4grhrj";
    fetchSubmodules = true;
  };

  # Avoid error: format not a string literal and
  # no format arguments [-Werror=format-security]
  preConfigure = ''
    substituteInPlace VTK/Common/Core/vtkLogger.h \
      --replace 'vtkLogScopeF(verbosity_name, __func__)' 'vtkLogScopeF(verbosity_name, "%s", __func__)'

    substituteInPlace VTK/Common/Core/vtkLogger.h \
      --replace 'vtkVLogScopeF(level, __func__)' 'vtkVLogScopeF(level, "%s", __func__)'
  '';

  # Find the Qt platform plugin "minimal"
  patchPhase = ''
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
    openmpi
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

  meta = with stdenv.lib; {
    homepage = "https://www.paraview.org/";
    description = "3D Data analysis and visualization application";
    license = licenses.free;
    maintainers = with maintainers; [ guibert ];
    platforms = platforms.linux;
  };
}
