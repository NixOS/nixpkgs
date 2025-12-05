{
  cmake,
  fetchFromGitHub,
  fetchpatch,
  makeWrapper,
  lib,
  stdenv,
  which,

  # build dependencies
  boost,
  curl,
  eigen,
  fftwFloat,
  gdal,
  itk,
  libsvm,
  libgeotiff,
  muparser,
  muparserx,
  opencv,
  perl,
  python3,
  shark,
  swig,
  tinyxml,

  # otb modules
  enableFFTW ? false,
  enableFeatureExtraction ? true,
  enableHyperspectral ? true,
  enableLearning ? true,
  enableMiscellaneous ? true,
  enableOpenMP ? false,
  enablePython ? true,
  extraPythonPackages ? ps: [ ],
  enableRemote ? true,
  enableShark ? true,
  enableSAR ? true,
  enableSegmentation ? true,
  enableStereoProcessing ? true,
  enableThirdParty ? true,
}:
let
  inherit (lib) optionals;
  pythonInputs =
    optionals enablePython (with python3.pkgs; [ numpy ]) ++ (extraPythonPackages python3.pkgs);

  # ITK configs for OTB requires 5.3.0 and
  # filter out gdcm, libminc from list of ITK deps as it's not needed for OTB
  itkVersion = "5.3.0";
  itkMajorMinorVersion = lib.versions.majorMinor itkVersion;
  itkDepsToRemove = [
    "gdcm"
    "libminc"
  ]
  ++ optionals (!enableFFTW) [
    # remove fftw to avoid GPL contamination
    # https://gitlab.orfeo-toolbox.org/orfeotoolbox/otb/-/issues/2454#note_112821
    "fftw"
  ];
  itkIsInDepsToRemove = dep: builtins.elem dep.name itkDepsToRemove;

  # remove after https://gitlab.orfeo-toolbox.org/orfeotoolbox/otb/-/issues/2451
  otbSwig = swig.overrideAttrs (oldArgs: {
    version = "4.2.1";
    src = fetchFromGitHub {
      owner = "swig";
      repo = "swig";
      tag = "v4.2.1";
      hash = "sha256-VlUsiRZLScmbC7hZDzKqUr9481YXVwo0eXT/jy6Fda8=";
    };
  });

  # override the ITK version with OTB version
  # https://gitlab.orfeo-toolbox.org/orfeotoolbox/otb/-/blob/develop/SuperBuild/CMake/External_itk.cmake?ref_type=heads#L145
  otb-itk = (itk.override { enableRtk = false; }).overrideAttrs (oldArgs: {
    version = itkVersion;
    src = fetchFromGitHub {
      owner = "InsightSoftwareConsortium";
      repo = "ITK";
      tag = "v${itkVersion}";
      hash = "sha256-+qCd8Jzpl5fEPTUpLyjjFBkfgCn3+Lf4pi8QnjCwofs=";
    };

    # https://gitlab.orfeo-toolbox.org/orfeotoolbox/otb/-/tree/develop/SuperBuild/patches/ITK?ref_type=heads
    patches = oldArgs.patches or [ ] ++ [
      ./itk-1-fftw-all.diff
      ./itk-2-totalprogress-all.diff
      # add gcc13 patch for itk 5.3.0 as well
      (fetchpatch {
        name = "fix-gcc13-build";
        url = "https://github.com/InsightSoftwareConsortium/ITK/commit/9a719a0d2f5f489eeb9351b0ef913c3693147a4f.patch";
        hash = "sha256-dDyqYOzo91afR8W7k2N64X6l7t6Ws1C9iuRkWHUe0fg=";
      })
    ];

    postPatch = ''
      substituteInPlace Modules/ThirdParty/KWSys/src/KWSys/CMakeLists.txt \
      --replace-fail 'cmake_minimum_required(VERSION 3.1 FATAL_ERROR)' 'cmake_minimum_required(VERSION 3.10)'
    '';

    # fix the CMake config files for ITK which contains double slashes
    postInstall = (oldArgs.postInstall or "") + ''
      sed -i 's|''${ITK_INSTALL_PREFIX}//nix/store|/nix/store|g' $out/lib/cmake/ITK-${itkMajorMinorVersion}/ITKConfig.cmake
    '';

    cmakeFlags = oldArgs.cmakeFlags or [ ] ++ [
      (lib.cmakeBool "ITK_USE_SYSTEM_EIGEN" true)

      # turn off all the itk modules from nixpkgs
      (lib.cmakeBool "ITK_USE_SYSTEM_GDCM" false)
      (lib.cmakeBool "ITK_USE_SYSTEM_MINC" false)
      (lib.cmakeBool "Module_ITKMINC" false)
      (lib.cmakeBool "Module_ITKIOMINC" false)
      (lib.cmakeBool "Module_ITKIOTransformMINC" false)
      (lib.cmakeBool "Module_SimpleITKFilters" false)
      (lib.cmakeBool "Module_ITKReview" false)
      (lib.cmakeBool "Module_MGHIO" false)
      (lib.cmakeBool "Module_AdaptiveDenoising" false)
      (lib.cmakeBool "Module_GenericLabelInterpolator" false)

      # enable itk modules for otb
      # https://gitlab.orfeo-toolbox.org/orfeotoolbox/otb/-/blob/develop/SuperBuild/CMake/External_itk.cmake?ref_type=heads
      # https://gitlab.orfeo-toolbox.org/orfeotoolbox/otb/-/blob/develop/SuperBuild/CMake/External_itk.cmake?ref_type=heads#L143
      (lib.cmakeBool "BUILD_TESTING" false)
      (lib.cmakeBool "ITK_BUILD_DEFAULT_MODULES" false)
      (lib.cmakeBool "ITKGroup_Core" false)
      (lib.cmakeBool "Module_ITKCommon" true)
      (lib.cmakeBool "Module_ITKFiniteDifference" true)
      (lib.cmakeBool "Module_ITKGPUCommon" true)
      (lib.cmakeBool "Module_ITKGPUFiniteDifference" true)
      (lib.cmakeBool "Module_ITKImageAdaptors" true)
      (lib.cmakeBool "Module_ITKImageFunction" true)
      (lib.cmakeBool "Module_ITKMesh" true)
      (lib.cmakeBool "Module_ITKQuadEdgeMesh" true)
      (lib.cmakeBool "Module_ITKSpatialObjects" true)
      (lib.cmakeBool "Module_ITKTransform" true)
      (lib.cmakeBool "Module_ITKAnisotropicSmoothing" true)
      (lib.cmakeBool "Module_ITKAntiAlias" true)
      (lib.cmakeBool "Module_ITKBiasCorrection" true)
      (lib.cmakeBool "Module_ITKBinaryMathematicalMorphology" true)
      (lib.cmakeBool "Module_ITKColormap" true)
      (lib.cmakeBool "Module_ITKConvolution" true)
      (lib.cmakeBool "Module_ITKCurvatureFlow" true)
      (lib.cmakeBool "Module_ITKDeconvolution" true)
      (lib.cmakeBool "Module_ITKDenoising" true)
      (lib.cmakeBool "Module_ITKDisplacementField" true)
      (lib.cmakeBool "Module_ITKDistanceMap" true)
      (lib.cmakeBool "Module_ITKFastMarching" true)
      (lib.cmakeBool "Module_ITKFFT" true)
      (lib.cmakeBool "Module_ITKGPUAnisotropicSmoothing" true)
      (lib.cmakeBool "Module_ITKGPUImageFilterBase" true)
      (lib.cmakeBool "Module_ITKGPUSmoothing" true)
      (lib.cmakeBool "Module_ITKGPUThresholding" true)
      (lib.cmakeBool "Module_ITKImageCompare" true)
      (lib.cmakeBool "Module_ITKImageCompose" true)
      (lib.cmakeBool "Module_ITKImageFeature" true)
      (lib.cmakeBool "Module_ITKImageFilterBase" true)
      (lib.cmakeBool "Module_ITKImageFusion" true)
      (lib.cmakeBool "Module_ITKImageGradient" true)
      (lib.cmakeBool "Module_ITKImageGrid" true)
      (lib.cmakeBool "Module_ITKImageIntensity" true)
      (lib.cmakeBool "Module_ITKImageLabel" true)
      (lib.cmakeBool "Module_ITKImageSources" true)
      (lib.cmakeBool "Module_ITKImageStatistics" true)
      (lib.cmakeBool "Module_ITKLabelMap" true)
      (lib.cmakeBool "Module_ITKMathematicalMorphology" true)
      (lib.cmakeBool "Module_ITKPath" true)
      (lib.cmakeBool "Module_ITKQuadEdgeMeshFiltering" true)
      (lib.cmakeBool "Module_ITKSmoothing" true)
      (lib.cmakeBool "Module_ITKSpatialFunction" true)
      (lib.cmakeBool "Module_ITKThresholding" true)
      (lib.cmakeBool "Module_ITKEigen" true)
      (lib.cmakeBool "Module_ITKNarrowBand" true)
      (lib.cmakeBool "Module_ITKOptimizers" true)
      (lib.cmakeBool "Module_ITKOptimizersv4" true)
      (lib.cmakeBool "Module_ITKPolynomials" true)
      (lib.cmakeBool "Module_ITKStatistics" true)
      (lib.cmakeBool "Module_ITKRegistrationCommon" true)
      (lib.cmakeBool "Module_ITKGPURegistrationCommon" true)
      (lib.cmakeBool "Module_ITKGPUPDEDeformableRegistration" true)
      (lib.cmakeBool "Module_ITKMetricsv4" true)
      (lib.cmakeBool "Module_ITKPDEDeformableRegistration" true)
      (lib.cmakeBool "Module_ITKRegistrationMethodsv4" true)
      (lib.cmakeBool "Module_ITKClassifiers" true)
      (lib.cmakeBool "Module_ITKConnectedComponents" true)
      (lib.cmakeBool "Module_ITKDeformableMesh" true)
      (lib.cmakeBool "Module_ITKKLMRegionGrowing" true)
      (lib.cmakeBool "Module_ITKLabelVoting" true)
      (lib.cmakeBool "Module_ITKLevelSets" true)
      (lib.cmakeBool "Module_ITKLevelSetsv4" true)
      (lib.cmakeBool "Module_ITKMarkovRandomFieldsClassifiers" true)
      (lib.cmakeBool "Module_ITKRegionGrowing" true)
      (lib.cmakeBool "Module_ITKSignedDistanceFunction" true)
      (lib.cmakeBool "Module_ITKVoronoi" true)
      (lib.cmakeBool "Module_ITKWatersheds" true)
    ];

    buildInputs = oldArgs.buildInputs or [ ] ++ [
      # add eigen as well as itk nixpkgs doesn't add it for version lower than 5.4.0
      eigen
    ];

    propagatedBuildInputs =
      lib.lists.filter (pkg: !(itkIsInDepsToRemove pkg)) oldArgs.propagatedBuildInputs or [ ]
      ++ lib.optionals enableFFTW [
        # the only missing dependency for OTB from itk propagated list if FFTW option is enabled
        fftwFloat
      ];

  });

  otb-shark = shark.override { enableOpenMP = enableOpenMP; };

in
stdenv.mkDerivation (finalAttrs: {
  pname = "otb";
  version = "10.0-unstable-2025-04-03";

  src = fetchFromGitHub {
    owner = "orfeotoolbox";
    repo = "otb";
    rev = "93649b68f54975a1a48a0acd49f2602a55fc8032";
    hash = "sha256-S6yhV//qlKdWWcT9J1p64WuVS0QNepIYTr/t4JvyEwE=";
  };

  patches = [
    # fixes for gdal 10
    # https://gitlab.orfeo-toolbox.org/orfeotoolbox/otb/-/merge_requests/1056
    (fetchpatch {
      url = "https://gitlab.orfeo-toolbox.org/orfeotoolbox/otb/-/merge_requests/1056/diffs.patch";
      hash = "sha256-Zj/wkx0vxn5vqj0hszn7NxoYW1yf63G3HPVKbSdZIOY=";
    })
    ./1-otb-swig-include-itk.diff
  ];

  postPatch = ''
    substituteInPlace Modules/Core/Wrappers/SWIG/src/python/CMakeLists.txt \
      --replace-fail ''\'''${ITK_INCLUDE_DIRS}' "${otb-itk}/include/ITK-${itkMajorMinorVersion}"
  ''
  # Add the header file "vcl_legacy_aliases.h", which defines the legacy vcl_* functions.
  # This patch fixes the unreproducible build of OTB.
  # See https://gitlab.orfeo-toolbox.org/orfeotoolbox/otb/-/issues/2484.
  + ''
    sed -i '/#include "vcl_compiler.h"/a #include "vcl_legacy_aliases.h"' Modules/Core/Mosaic/include/otbMosaicFunctors.h
  '';

  nativeBuildInputs = [
    cmake
    makeWrapper
    which
  ];

  # https://www.orfeo-toolbox.org/CookBook/CompilingOTBFromSource.html#native-build-with-system-dependencies
  # activates all modules and python by default
  cmakeFlags = [
    (lib.cmakeBool "OTBGroup_Core" true)
    (lib.cmakeBool "OTB_BUILD_FeaturesExtraction" enableFeatureExtraction)
    (lib.cmakeBool "OTB_BUILD_Hyperspectral" enableHyperspectral)
    (lib.cmakeBool "OTB_BUILD_Learning" enableLearning)
    (lib.cmakeBool "OTB_BUILD_Miscellaneous" enableMiscellaneous)
    (lib.cmakeBool "OTB_USE_OPENMP" enableOpenMP)
    (lib.cmakeBool "OTB_BUILD_RemoteModules" enableRemote)
    (lib.cmakeBool "OTB_BUILD_SAR" enableSAR)
    (lib.cmakeBool "OTB_USE_SHARK" enableShark)
    (lib.cmakeBool "OTB_BUILD_Segmentation" enableSegmentation)
    (lib.cmakeBool "OTB_BUILD_StereoProcessing" enableStereoProcessing)
    (lib.cmakeBool "OTBGroup_ThirdParty" enableThirdParty)
    (lib.cmakeBool "OTB_WRAP_PYTHON" enablePython)
    (lib.cmakeBool "BUILD_TESTING" finalAttrs.doInstallCheck)
    (lib.cmakeBool "OTB_USE_FFTW" enableFFTW)
  ];

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
    perl
    tinyxml
  ]
  ++ otb-itk.propagatedBuildInputs
  ++ optionals enablePython (
    [
      python3
      otbSwig
    ]
    ++ pythonInputs
  )
  ++ optionals enableShark [ otb-shark ];

  doInstallCheck = true;

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
    teams = [ lib.teams.geospatial ];
    platforms = lib.platforms.linux;
  };
})
