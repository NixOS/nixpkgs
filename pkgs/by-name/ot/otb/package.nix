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
  version = "9.1.0";

  src = fetchFromGitHub {
    owner = "orfeotoolbox";
    repo = "otb";
    rev = finalAttrs.version;
    hash = "sha256-NRyq6WTGxtPpBHXBXLCQyq60n0cJ/575xPs7QYSziYo=";
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
    optional enableFeatureExtraction "-DOTB_BUILD_FeaturesExtraction=ON"
    ++ optional enableHyperspectral "-DOTB_BUILD_Hyperspectral=ON"
    ++ optional enableLearning "-DOTB_BUILD_Learning=ON"
    ++ optional enableMiscellaneous "-DOTB_BUILD_Miscellaneous=ON"
    ++ optional enableOpenMP "-DOTB_USE_OPENMP=ON"
    ++ optional enableRemote "-DOTB_BUILD_RemoteModules=ON"
    ++ optional enableSAR "-DOTB_BUILD_SAR=ON"
    ++ optional enableSegmentation "-DOTB_BUILD_Segmentation=ON"
    ++ optional enableStereoProcessing "-DOTB_BUILD_StereoProcessing=ON"
    ++ optional enablePython "-DOTB_WRAP_PYTHON=ON"
    ++ optional finalAttrs.doInstallCheck "-DBUILD_TESTING=ON";

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

  doInstallCheck = false;

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
