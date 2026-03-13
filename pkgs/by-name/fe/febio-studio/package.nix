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
  fetchpatch,
  sshSupport ? true,
  openssl,
  libssh,
  tetgenSupport ? true,
  tetgen,
  ffmpegSupport ? true,
  ffmpeg,
  dicomSupport ? false,
  dcmtk,
  withModelRepo ? true,
  withCadFeatures ? false,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "febio-studio";
  version = "2.8.1";

  src = fetchFromGitHub {
    owner = "febiosoftware";
    repo = "FEBioStudio";
    rev = "v${finalAttrs.version}";
    hash = "sha256-ynKo7WK529146Tk//PO5tMsqvfKM4nq3fgPXMGjWwIk=";
  };

  patches = [
    ./cmake-install.patch
    # Fix qt 6.8 compile, can be removed after next release
    (fetchpatch {
      url = "https://github.com/febiosoftware/FEBioStudio/commit/15524d958a6f5ef81ccee58b4efa1ea25de91543.patch";
      hash = "sha256-LRToK1/RQC+bLXgroDTQOV6H8pI+IZ38Y0nsl/Fz1WE=";
    })
  ];

  cmakeFlags = [
    (lib.cmakeFeature "Qt_Root" "${qt6Packages.qtbase}")
  ]
  ++ lib.optional sshSupport "-DUSE_SSH=On"
  ++ lib.optional tetgenSupport "-DUSE_TETGEN=On"
  ++ lib.optional ffmpegSupport "-DUSE_FFMPEG=On"
  ++ lib.optional dicomSupport "-DUSE_DICOM=On"
  ++ lib.optional withModelRepo "-DMODEL_REPO=On"
  ++ lib.optional withCadFeatures "-DCAD_FEATURES=On";

  nativeBuildInputs = [
    cmake
    ninja
    qt6Packages.wrapQtAppsHook
  ];

  buildInputs = [
    zlib
    libGLU
    glew
    qt6Packages.qtbase
    febio
  ]
  ++ lib.optionals sshSupport [
    openssl
    libssh
  ]
  ++ lib.optional tetgenSupport tetgen
  ++ lib.optional ffmpegSupport ffmpeg
  ++ lib.optional dicomSupport dcmtk;

  meta = {
    description = "FEBio Suite Solver";
    mainProgram = "FEBioStudio";
    license = with lib.licenses; [ mit ];
    homepage = "https://febio.org/";
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ Scriptkiddi ];
  };
})
