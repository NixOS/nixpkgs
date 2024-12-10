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
  version = "5.11.2";

  docFiles = [
    (fetchurl {
      url = "https://www.paraview.org/paraview-downloads/download.php?submit=Download&version=v${lib.versions.majorMinor version}&type=data&os=Sources&downloadFile=ParaViewTutorial-${version}.pdf";
      name = "Tutorial.pdf";
      hash = "sha256-KIcd5GG+1L3rbj4qdLbc+eDa5Wy4+nqiVIxfHu5Tdpg=";
    })
    (fetchurl {
      url = "https://www.paraview.org/paraview-downloads/download.php?submit=Download&version=v${lib.versions.majorMinor version}&type=data&os=Sources&downloadFile=ParaViewGettingStarted-${version}.pdf";
      name = "GettingStarted.pdf";
      hash = "sha256-ptPQA8By8Hj0qI5WRtw3ZhklelXeYeJwVaUdfd6msJM=";
    })
    (fetchurl {
      url = "https://www.paraview.org/paraview-downloads/download.php?submit=Download&version=v${lib.versions.majorMinor version}&type=data&os=Sources&downloadFile=ParaViewCatalystGuide-${version}.pdf";
      name = "CatalystGuide.pdf";
      hash = "sha256-imRW70lGQX7Gy0AavIHQMVhnn9E2FPpiCdCKt7Jje4w=";
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
    hash = "sha256-fe/4xxxlkal08vE971FudTnESFfGMYzuvSyAMS6HSxI=";
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

  patches = [
    ./dont-redefine-strlcat.patch
  ];

  env.CXXFLAGS = "-include cstdint";

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

  meta = with lib; {
    homepage = "https://www.paraview.org/";
    description = "3D Data analysis and visualization application";
    license = licenses.bsd3;
    maintainers = with maintainers; [ guibert ];
    platforms = platforms.linux;
  };
}
