{ stdenv, fetchFromGitHub, cmake, makeWrapper, qtbase , qttools, python
, libGLU, libGL , libXt, qtx11extras, qtxmlpatterns , mkDerivation }:

mkDerivation rec {
  pname = "paraview";
  version = "5.6.3";

  # fetching from GitHub instead of taking an "official" source
  # tarball because of missing submodules there
  src = fetchFromGitHub {
    owner = "Kitware";
    repo = "ParaView";
    rev = "v${version}";
    sha256 = "0zcij59pg47c45gfddnpbin13w16smzhcbivzm1k4pg4366wxq1q";
    fetchSubmodules = true;
  };

  cmakeFlags = [
    "-DPARAVIEW_ENABLE_PYTHON=ON"
    "-DPARAVIEW_INSTALL_DEVELOPMENT_FILES=ON"
    "-DPARAVIEW_ENABLE_EMBEDDED_DOCUMENTATION=OFF"
    "-DOpenGL_GL_PREFERENCE=GLVND"
  ];

  # During build, binaries are called that rely on freshly built
  # libraries.  These reside in build/lib, and are not found by
  # default.
  preBuild = ''
    export LD_LIBRARY_PATH=$LD_LIBRARY_PATH''${LD_LIBRARY_PATH:+:}$PWD/lib:$PWD/VTK/ThirdParty/vtkm/vtk-m/lib
  '';

  enableParallelBuilding = true;

  nativeBuildInputs = [
    cmake
    makeWrapper
  ];

  buildInputs = [
    python
    python.pkgs.numpy
    libGLU libGL
    libXt
    qtbase
    qtx11extras
    qttools
    qtxmlpatterns
  ];

  # Paraview links into the Python library, resolving symbolic links on the way,
  # so we need to put the correct sitePackages (with numpy) back on the path
  preFixup = ''
    wrapQtApp $out/bin/paraview \
      --prefix PYTHONPATH "${python.pkgs.numpy}/${python.sitePackages}"
    wrapQtApp $out/bin/pvbatch \
      --prefix PYTHONPATH "${python.pkgs.numpy}/${python.sitePackages}"
    wrapQtApp $out/bin/pvpython \
      --prefix PYTHONPATH "${python.pkgs.numpy}/${python.sitePackages}"
  '';

  meta = with stdenv.lib; {
    homepage = http://www.paraview.org/;
    description = "3D Data analysis and visualization application";
    license = licenses.free;
    maintainers = with maintainers; [ guibert ];
    platforms = platforms.linux;
  };
}
