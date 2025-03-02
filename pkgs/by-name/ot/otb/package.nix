{
  cmake,
  callPackage,
  fetchFromGitHub,
  makeWrapper,
  lib,
  stdenv,
  swig,
  which,
  boost,
  curl,
  gdal,
  libsvm,
  libgeotiff,
  muparser,
  muparserx,
  opencv,
  perl,
  python3,
  shark,
  tinyxml,
  enableFeatureExtraction ? true,
  enableHyperspectral ? true,
  enableLearning ? true,
  enableMiscellaneous ? true,
  enableOpenMP ? false,
  enablePython ? true,
  extraPythonPackages ? ps: with ps; [ ],
  enableRemote ? true,
  enableSAR ? true,
  enableSegmentation ? true,
  enableStereoProcessing ? true,
}:
let
  inherit (lib) optionalString optionals optional;
  pythonInputs =
    optionals enablePython (with python3.pkgs; [ numpy ]) ++ (extraPythonPackages python3.pkgs);

  otb-itk = callPackage ./itk_4_13/package.nix { };
  otb-shark = shark.override { enableOpenMP = enableOpenMP; };

in
stdenv.mkDerivation (finalAttrs: {
  pname = "otb";
  version = "9.0.0";

  src = fetchFromGitHub {
    owner = "orfeotoolbox";
    repo = "otb";
    tag = finalAttrs.version;
    hash = "sha256-Ut2aimQL6Reg62iceoaM7/nRuEV8PBWtOK7KFHKp0ws=";
  };

  nativeBuildInputs = [
    cmake
    makeWrapper
    swig
    which
  ];

  # https://www.orfeo-toolbox.org/CookBook/CompilingOTBFromSource.html#native-build-with-system-dependencies
  # activates all modules and python by default
  cmakeFlags =
    optional enableFeatureExtraction (lib.cmakeBool "OTB_BUILD_FeaturesExtraction" true)
    ++ optional enableHyperspectral (lib.cmakeBool "OTB_BUILD_Hyperspectral" true)
    ++ optional enableLearning (lib.cmakeBool "OTB_BUILD_Learning" true)
    ++ optional enableMiscellaneous (lib.cmakeBool "OTB_BUILD_Miscellaneous" true)
    ++ optional enableOpenMP (lib.cmakeBool "OTB_USE_OPENMP" true)
    ++ optional enableRemote (lib.cmakeBool "OTB_BUILD_RemoteModules" true)
    ++ optional enableSAR (lib.cmakeBool "OTB_BUILD_SAR" true)
    ++ optional enableSegmentation (lib.cmakeBool "OTB_BUILD_Segmentation" true)
    ++ optional enableStereoProcessing (lib.cmakeBool "OTB_BUILD_StereoProcessing" true)
    ++ optional enablePython (lib.cmakeBool "OTB_WRAP_PYTHON" true)
    ++ optional finalAttrs.doInstallCheck (lib.cmakeBool "BUILD_TESTING" true);

  propagatedBuildInputs = [
    boost
    curl
    gdal
    libgeotiff
    libsvm
    muparser
    muparserx
    opencv
    otb-itk
    otb-shark
    perl
    swig
    tinyxml
  ] ++ optionals enablePython ([ python3 ] ++ pythonInputs);

  doInstallCheck = true;

  pythonPath = optionals enablePython pythonInputs;

  postInstall = ''
    wrapProgram $out/bin/otbcli \
    --set OTB_INSTALL_DIR "$out" \
    --set OTB_APPLICATION_PATH "$out/lib/otb/applications"
  '';

  meta = {
    description = "Open Source processing of remote sensing images";
    homepage = "https://www.orfeo-toolbox.org/";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ daspk04 ];
  };
})
