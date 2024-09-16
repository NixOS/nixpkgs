{
  lib,
  stdenv,
  overrideSDK,
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
  ffmpeg_7,
  dicomSupport ? false,
  dcmtk,
  withModelRepo ? true,
  withCadFeatures ? false,
}:

let
  stdenv' =
    if stdenv.isDarwin then
      overrideSDK stdenv {
        darwinSdkVersion = "11.0";
        darwinMinVersion = "10.15";
      }
    else
      stdenv;
in

stdenv'.mkDerivation (finalAttrs: {
  pname = "febio-studio";
  version = "2.7";

  src = fetchFromGitHub {
    owner = "febiosoftware";
    repo = "FEBioStudio";
    rev = "v${finalAttrs.version}";
    hash = "sha256-ggIzz6bvNjqlI8s31EVnbM0TOspBSc9/myKpWukS3MU=";
  };

  patches = [ ./cmake-install.patch ];

  cmakeFlags =
    [ (lib.cmakeFeature "Qt_Root" "${qt6Packages.qtbase}") ]
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

  buildInputs =
    [
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
    ++ lib.optional ffmpegSupport ffmpeg_7
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
