{ lib, stdenv, fetchFromGitLab, fetchurl
, boost, cmake, ffmpeg, qtbase, qtx11extras
, qttools, qtxmlpatterns, qtsvg, gdal, gfortran, libXt, makeWrapper
, mkDerivation, ninja, mpi, python3, tbb, libGLU, libGL
, withDocs ? true
}:

let
  version = "5.10.0";

  docFiles = [
    (fetchurl {
      url = "https://www.paraview.org/paraview-downloads/download.php?submit=Download&version=v${lib.versions.majorMinor version}&type=data&os=Sources&downloadFile=ParaViewTutorial-${version}.pdf";
      name = "Tutorial.pdf";
      sha256 = "1knpirjbz3rv8p8n03p39vv8vi5imvxakjsssqgly09g0cnsikkw";
    })
    (fetchurl {
      url = "https://www.paraview.org/paraview-downloads/download.php?submit=Download&version=v${lib.versions.majorMinor version}&type=data&os=Sources&downloadFile=ParaViewGettingStarted-${version}.pdf";
      name = "GettingStarted.pdf";
      sha256 = "14xhlvg7s7d5amqf4qfyamx2a6b66zf4cmlfm3s7iw3jq01x1lx6";
    })
    (fetchurl {
      url = "https://www.paraview.org/paraview-downloads/download.php?submit=Download&version=v${lib.versions.majorMinor version}&type=data&os=Sources&downloadFile=ParaViewCatalystGuide-${version}.pdf";
      name = "CatalystGuide.pdf";
      sha256 = "133vcfrbg2nh15igl51ns6gnfn1is20vq6j0rg37wha697pmcr4a";
    })
  ];

in mkDerivation rec {
  pname = "paraview";
  inherit version;

  src = fetchFromGitLab {
    domain = "gitlab.kitware.com";
    owner = "paraview";
    repo = "paraview";
    rev = "v${version}";
    sha256 = "0ipx6zq44hpic7gvv0s2jvjncak6vlmrz5sp9ypc15b15bna0gs2";
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
    libGLU
    libGL
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

  postInstall = let docDir = "$out/share/paraview-${lib.versions.majorMinor version}/doc"; in
    lib.optionalString withDocs ''
      mkdir -p ${docDir};
      for docFile in ${lib.concatStringsSep " " docFiles}; do
        cp $docFile ${docDir}/$(stripHash $docFile);
      done;
    '';

  propagatedBuildInputs = [
    (python3.withPackages (ps: with ps; [ numpy matplotlib mpi4py ]))
  ];

  meta = with lib; {
    homepage = "https://www.paraview.org/";
    description = "3D Data analysis and visualization application";
    license = licenses.bsd3;
    maintainers = with maintainers; [ guibert ];
    platforms = platforms.linux;
  };
}
