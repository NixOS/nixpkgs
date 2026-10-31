{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  ninja,
  zlib,
  libGLU,
  qt6Packages,
  febio,
  glew,
  sshSupport ? true,
  openssl,
  libssh,
  tetgenSupport ? true,
  tetgen,
  ffmpegSupport ? true,
  ffmpeg,
  dicomSupport ? false,
  dcmtk,
  itkSupport ? false,
  simpleitk,
  withModelRepo ? true,
  withCadFeatures ? false,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "febio-studio";
  version = "3.2";

  src = fetchFromGitHub {
    owner = "febiosoftware";
    repo = "FEBioStudio";
    rev = "v${finalAttrs.version}";
    hash = "sha256-BHbcMxRH5MxcrwQTd353091fFasfUFxhK+dlJiPEIgU=";
  };

  patches = [
    ./cmake-install.patch

    # PythonRunner.cpp includes pybind11 outside of the #ifdef HAS_PYTHON guard
    # that every other file in PyLib uses, so it fails to build without Python
    # support.
    ./python-guard.patch
  ];

  cmakeFlags = [
    (lib.cmakeFeature "Qt_Root" "${qt6Packages.qtbase}")
    # Required so that Qt6::GuiPrivate, which is linked unconditionally, is
    # actually looked up by FindDependencies.cmake.
    (lib.cmakeBool "QT_6_10" (lib.versionAtLeast qt6Packages.qtbase.version "6.10"))
    # Must be set explicitly: FindDependencies.cmake tests `DEFINED
    # SimpleITK_FOUND`, which also holds when the find_package() failed, so
    # USE_ITK would otherwise default to On without SimpleITK present.
    (lib.cmakeBool "USE_ITK" itkSupport)
  ]
  ++ lib.optional sshSupport "-DUSE_SSH=On"
  ++ lib.optional tetgenSupport "-DUSE_TETGEN=On"
  ++ lib.optionals ffmpegSupport [
    "-DUSE_FFMPEG=On"
    # FFmpeg 8 removed avcodec_close(); upstream hides the replacement behind
    # this flag.
    (lib.cmakeBool "USE_NEW_FFMPEG" (lib.versionAtLeast ffmpeg.version "8"))
  ]
  ++ lib.optional dicomSupport "-DUSE_DICOM=On"
  ++ lib.optional withModelRepo "-DMODEL_REPO=On"
  ++ lib.optional withCadFeatures "-DCAD_FEATURES=On";

  nativeBuildInputs = [
    cmake
    ninja
    # Provides the qsb shader compiler used by qt_add_shaders()
    qt6Packages.qtshadertools
    qt6Packages.wrapQtAppsHook
  ];

  buildInputs = [
    zlib
    libGLU
    glew
    qt6Packages.qtbase
    qt6Packages.qtshadertools
    febio
  ]
  ++ lib.optionals sshSupport [
    openssl
    libssh
  ]
  ++ lib.optional tetgenSupport tetgen
  ++ lib.optional ffmpegSupport ffmpeg
  ++ lib.optional dicomSupport dcmtk
  ++ lib.optional itkSupport simpleitk;

  meta = {
    description = "FEBio Suite Solver";
    mainProgram = "FEBioStudio";
    license = lib.licenses.mit;
    homepage = "https://febio.org/";
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ Scriptkiddi ];
  };
})
