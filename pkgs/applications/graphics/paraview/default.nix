{
  lib,
  stdenv,
  fetchFromGitLab,
  fetchurl,
  boost,
  cmake,
  ffmpeg,
  wrapQtAppsHook,
  qtbase,
  qtx11extras,
  qttools,
  qtxmlpatterns,
  qtsvg,
  gdal,
  gfortran,
  libXt,
  makeWrapper,
  ninja,
  mpi,
  python3,
  tbb,
  libGLU,
  libGL,
  withDocs ? true,
}:

let
  version = "5.13.0";

  docFiles = [
    (fetchurl {
      url = "https://www.paraview.org/paraview-downloads/download.php?submit=Download&version=v${lib.versions.majorMinor version}&type=data&os=Sources&downloadFile=ParaViewTutorial-${version}.pdf";
      name = "Tutorial.pdf";
      hash = "sha256-hoCa/aTy2mmsPHP3Zm0hLZlZKbtUMpjUlc2rFKKChco=";
    })
    (fetchurl {
      url = "https://www.paraview.org/paraview-downloads/download.php?submit=Download&version=v${lib.versions.majorMinor version}&type=data&os=Sources&downloadFile=ParaViewGettingStarted-${version}.pdf";
      name = "GettingStarted.pdf";
      hash = "sha256-ptPQA8By8Hj0qI5WRtw3ZhklelXeYeJwVaUdfd6msJM=";
    })
    (fetchurl {
      url = "https://www.paraview.org/paraview-downloads/download.php?submit=Download&version=v${lib.versions.majorMinor version}&type=data&os=Sources&downloadFile=ParaViewCatalystGuide-${version}.pdf";
      name = "CatalystGuide.pdf";
      hash = "sha256-t1lJ1Wiswhdxovt2O4sXTXfFxshDiZZVdnkXt/+BQn8=";
    })
  ];

in
stdenv.mkDerivation rec {
  pname = "paraview";
  inherit version;

  src = fetchFromGitLab {
    domain = "gitlab.kitware.com";
    owner = "paraview";
    repo = "paraview";
    rev = "v${version}";
    hash = "sha256-JRSuvBON2n0UnbrFia4Qmf6eYb1Mc+Z7dIcXSeUhpIc=";
    fetchSubmodules = true;
  };

  # Find the Qt platform plugin "minimal"
  preConfigure = ''
    export QT_PLUGIN_PATH=${qtbase.bin}/${qtbase.qtPluginPrefix}
  '';

  cmakeFlags = [
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
    wrapQtAppsHook
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

  postInstall =
    let
      docDir = "$out/share/paraview-${lib.versions.majorMinor version}/doc";
    in
    lib.optionalString withDocs ''
      mkdir -p ${docDir};
      for docFile in ${lib.concatStringsSep " " docFiles}; do
        cp $docFile ${docDir}/$(stripHash $docFile);
      done;
    '';

  propagatedBuildInputs = [
    (python3.withPackages (
      ps: with ps; [
        numpy
        matplotlib
        mpi4py
      ]
    ))
  ];

  meta = {
    homepage = "https://www.paraview.org";
    description = "3D Data analysis and visualization application";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ guibert ];
    changelog = "https://www.kitware.com/paraview-${lib.concatStringsSep "-" (lib.versions.splitVersion version)}-release-notes";
    platforms = lib.platforms.linux;
  };
}
