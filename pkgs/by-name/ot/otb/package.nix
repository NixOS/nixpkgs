{
  cmake,
  fetchFromGitHub,
  fetchFromGitLab,
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
  enableRemote ? false,
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

  fetchOtbModule =
    {
      repo,
      rev,
      hash,
    }:
    fetchFromGitLab {
      domain = "gitlab.orfeo-toolbox.org";
      owner = "orfeotoolbox/otb-modules";
      inherit repo rev hash;
    };
  otbModules =
    optionals enableFeatureExtraction [
      {
        name = "FeaturesExtraction";
        src = fetchOtbModule {
          repo = "featuresextraction";
          rev = "c7edb5f77f5da4363c3d947f6f576ea100c2b178";
          hash = "sha256-4LorhzFm0fvR88/F7E5epYUFkIv9aHfdQSuxfNRWq6I=";
        };
      }
    ]
    ++ optionals enableLearning [
      {
        name = "Learning";
        src = fetchOtbModule {
          repo = "learning";
          rev = "0e05670e5806bcc78e6ea1fc25ce70977506646d";
          hash = "sha256-AsHBPxIKqMeRgb6uLnr1BFoJVcemoYs/m4h4nkgLURg=";
        };
      }
    ]
    ++ optionals enableSAR [
      {
        name = "SAR";
        src = fetchOtbModule {
          repo = "sar";
          rev = "d278c3cba9475c170012230afecf50d8d086c37f";
          hash = "sha256-0XL7JJifqk+4Lhk64jBba+ZZ+wdFxN8IdD5aRMGoRhc=";
        };
      }
    ]
    ++ optionals enableSegmentation [
      {
        name = "Segmentation";
        src = fetchOtbModule {
          repo = "segmentation";
          rev = "2e6910f5672a3dd03866d168bf0a72cf89c0ca3e";
          hash = "sha256-44t2mxfBK15WaCDMDa4ljzS5UyVpSEfbRKFsCdQP97s=";
        };
      }
    ]
    ++ optionals enableHyperspectral [
      {
        name = "Hyperspectral";
        src = fetchOtbModule {
          repo = "hyperspectral";
          rev = "34c6ed806ddb576082694ffc1ba0f9bb16e05f72";
          hash = "sha256-9Bs6trDTqqjOzdjvP0zOzCiOJjW44wSmHOeveBNa9d0=";
        };
      }
    ]
    ++ optionals enableStereoProcessing [
      {
        name = "StereoProcessing";
        src = fetchOtbModule {
          repo = "stereoprocessing";
          rev = "8ee7dddd729197d52eead0933621cfa1cb9f171f";
          hash = "sha256-pkwp4zTuB+zg2T8lSIqwgNMydJfIcCRf6pzVpdlDk8o=";
        };
      }
    ]
    ++ optionals enableMiscellaneous [
      {
        name = "Miscellaneous";
        src = fetchOtbModule {
          repo = "miscellaneous";
          rev = "a65337c6b95f12bfe8c87d0ee7f1e2d9d9e0804e";
          hash = "sha256-8gV03IQKGypJWblKka10duqnWViXoF63394E22otBDE=";
        };
      }
    ];

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
      # fix build with GCC 15
      substituteInPlace Modules/ThirdParty/GoogleTest/src/itkgoogletest/googletest/src/gtest-death-test.cc \
        --replace-fail \
          '#include <utility>' \
          '#include <utility>
          #include <cstdint>'
      substituteInPlace Modules/Core/Common/include/itkFloatingPointExceptions.h \
        --replace-fail \
          '#include "itkSingletonMacro.h"' \
          '#include "itkSingletonMacro.h"
          #include <cstdint>'
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
  version = "10.0.0-rc1";

  __structuredAttrs = true;
  strictDeps = true;

  src = fetchFromGitHub {
    owner = "orfeotoolbox";
    repo = "otb";
    tag = finalAttrs.version;
    hash = "sha256-c8o1iGPacaceZ8VnG5gzN7lnCTLS5Nkb1jajtLBfzmw=";
  };

  patches = [
    ./1-otb-swig-include-itk.diff
    # GDAL >= 3.13 returns CSLConstList from GDALGetMetadata, which no longer converts to char**.
    ./2-otb-gdal-cslconstlist.diff
    # Use the module sources copied into the tree instead of attempting network access.
    ./3-use-packaged-modules.diff
  ];

  postPatch = ''
    substituteInPlace Modules/Core/Wrappers/SWIG/src/python/CMakeLists.txt \
      --replace-fail \
        ''\'''${ITK_INCLUDE_DIRS}' \
        "${lib.getInclude otb-itk}/include/ITK-${itkMajorMinorVersion}"
  ''
  + lib.concatMapStringsSep "\n" (
    module: "cp -r --no-preserve=mode ${module.src} Modules/${module.name}"
  ) otbModules;

  # Some core targets include ITK headers indirectly through otbMacro.h without declaring
  # OTBITK as a module dependency, so its include directory is missing during compilation.
  env.NIX_CFLAGS_COMPILE = "-I${otb-itk}/include/ITK-${itkMajorMinorVersion}";

  nativeBuildInputs = [
    cmake
    makeWrapper
    which
  ]
  ++ optionals enablePython [
    python3
    swig
  ];

  # https://www.orfeo-toolbox.org/CookBook/CompilingOTBFromSource.html#native-build-with-system-dependencies
  # activates all modules and python by default
  cmakeFlags = [
    # Let OTB use LD_LIBRARY_PATH when running build-time tools; Nix adds the final RPATHs during fixup.
    (lib.cmakeBool "CMAKE_SKIP_RPATH" true)
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
      swig
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
