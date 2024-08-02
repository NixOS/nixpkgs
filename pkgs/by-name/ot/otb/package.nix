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
assert enablePython -> python3 != null;
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
    rev = finalAttrs.version;
    hash = "sha256-Ut2aimQL6Reg62iceoaM7/nRuEV8PBWtOK7KFHKp0ws=";
  };

  nativeBuildInputs = [
    cmake
    makeWrapper
    swig
    which
  ];

  buildInputs = [
    boost
    curl
    gdal
    libsvm
    libgeotiff
    muparser
    muparserx
    opencv
    otb-itk
    otb-shark
    perl
    tinyxml
  ] ++ optionals enablePython [ python3 ] ++ optionals enablePython pythonInputs;

  # https://www.orfeo-toolbox.org/CookBook/CompilingOTBFromSource.html#native-build-with-system-dependencies
  # activates all modules and python by default
  cmakeFlags =
    [ ]
    ++ optionals enableFeatureExtraction [ "-DOTB_BUILD_FeaturesExtraction=ON" ]
    ++ optionals enableHyperspectral [ "-DOTB_BUILD_Hyperspectral=ON" ]
    ++ optionals enableLearning [ "-DOTB_BUILD_Learning=ON" ]
    ++ optionals enableMiscellaneous [ "-DOTB_BUILD_Miscellaneous=ON" ]
    ++ optionals enableOpenMP [ "-DOTB_USE_OPENMP=ON" ]
    ++ optionals enableRemote [ "-DOTB_BUILD_RemoteModules=ON" ]
    ++ optionals enableSAR [ "-DOTB_BUILD_SAR=ON" ]
    ++ optionals enableSegmentation [ "-DOTB_BUILD_Segmentation=ON" ]
    ++ optionals enableStereoProcessing [ "-DOTB_BUILD_StereoProcessing=ON" ]
    ++ optionals enablePython [ "-DOTB_WRAP_PYTHON=ON" ]
    ++ optionals finalAttrs.doInstallCheck [ "-DBUILD_TESTING=ON" ];

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
  ] ++ optionals enablePython [ python3 ] ++ optionals enablePython pythonInputs;

  doInstallCheck = false;

  pythonPath = optionals enablePython pythonInputs;

  postInstall = ''
    wrapProgram $out/bin/otbcli \
        --set OTB_INSTALL_DIR "$out" \
        --set OTB_APPLICATION_PATH "$out/lib/otb/applications"
  '';

  meta = {
    description = "Orfeo ToolBox";
    homepage = "https://www.orfeo-toolbox.org/";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ daspk04 ];
  };
})
