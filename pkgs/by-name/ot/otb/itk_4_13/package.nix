{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  expat,
  fftw,
  fftwFloat,
  hdf5-cpp,
  libjpeg,
  libtiff,
  libpng,
  libuuid,
  xz,
  vtk,
  zlib,
}:
# this ITK version is old and is only required for OTB package
# https://gitlab.orfeo-toolbox.org/orfeotoolbox/otb/-/blob/develop/SuperBuild/CMake/External_itk.cmake?ref_type=heads#L149
stdenv.mkDerivation (finalAttrs: {
  pname = "itk";
  version = "4.13.3";

  src = fetchFromGitHub {
    owner = "InsightSoftwareConsortium";
    repo = "ITK";
    tag = "v${finalAttrs.version}";
    hash = "sha256-lcoJ+H+nVlvleBqbmupu+yg+4iZQ4mTs9pt1mQac+xg=";
  };

  # https://gitlab.orfeo-toolbox.org/orfeotoolbox/otb/-/tree/develop/SuperBuild/patches/ITK?ref_type=heads
  patches = [
    ./itk-1-fftw-all.diff
    ./itk-2-itktestlib-all.diff
    ./itk-3-remove-gcc-version-debian-medteam-all.diff
  ];

  # https://gitlab.orfeo-toolbox.org/orfeotoolbox/otb/-/blob/develop/SuperBuild/CMake/External_itk.cmake?ref_type=heads
  cmakeFlags = [
    (lib.cmakeBool "BUILD_TESTING" false)
    (lib.cmakeBool "BUILD_EXAMPLES" false)
    (lib.cmakeBool "BUILD_SHARED_LIBS" true)
    (lib.cmakeBool "ITK_BUILD_DEFAULT_MODULES" false)
    (lib.cmakeBool "ITKGroup_Core" false)
    (lib.cmakeBool "ITK_FORBID_DOWNLOADS" true)
    (lib.cmakeBool "ITK_USE_SYSTEM_LIBRARIES" true) # finds common libraries e.g. hdf5, libpng, libtiff, libjpeg, zlib etc
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
    (lib.cmakeBool "Module_ITKTransformFactory" true)
    (lib.cmakeBool "Module_ITKIOTransformBase" true)
    (lib.cmakeBool "Module_ITKIOTransformInsightLegacy" true)
    (lib.cmakeBool "Module_ITKIOTransformMatlab" true)
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
    (lib.cmakeBool "Module_ITKNeuralNetworks" true)
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

  nativeBuildInputs = [
    cmake
    xz
  ];
  buildInputs = [ libuuid ];
  propagatedBuildInputs = [
    # similar to 5.2.x, we progagate these inputs for OTB
    expat
    fftw
    fftwFloat
    hdf5-cpp
    libjpeg
    libpng
    libtiff
    zlib
  ];

  meta = {
    description = "Insight Segmentation and Registration Toolkit";
    homepage = "https://www.itk.org";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ daspk04 ];
    platforms = with lib.platforms; linux;
  };
})
