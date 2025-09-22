{
  lib,
  stdenv,
  config,
  fetchFromGitHub,
  fetchpatch,
  cmake,
  gtest,
  doCheck ? true,
  cudaSupport ? config.cudaSupport or false,
  openclSupport ? false,
  mpiSupport ? false,
  javaWrapper ? false,
  hdfsSupport ? false,
  pythonLibrary ? false,
  rLibrary ? false,
  cudaPackages,
  opencl-headers,
  ocl-icd,
  boost,
  llvmPackages,
  openmpi,
  openjdk,
  swig,
  hadoop,
  R,
  rPackages,
  pandoc,
  python3Packages,
}:

assert doCheck -> !mpiSupport;
assert openclSupport -> !cudaSupport;
assert cudaSupport -> !openclSupport;

stdenv.mkDerivation (finalAttrs: {
  # prefix with r when building the R library
  # The R package build results in a special binary file
  # that contains a subset of the .so file use for the CLI
  # and python version. In general, the CRAN version from
  # nixpkgs's r-modules should be used, but this non-standard
  # build allows for enabling CUDA support and other features
  # which aren't included in the CRAN release. Build with:
  # nix-build -E "with (import $NIXPKGS{}); \
  #   let \
  #     lgbm = lightgbm.override{rLibrary = true; doCheck = false;}; \
  #   in \
  #   rWrapper.override{ packages = [ lgbm ]; }"
  pname = lib.optionalString rLibrary "r-" + "lightgbm";
  version = "4.6.0";

  src = fetchFromGitHub {
    owner = "microsoft";
    repo = "lightgbm";
    tag = "v${finalAttrs.version}";
    fetchSubmodules = true;
    hash = "sha256-vq/TlM87i1GNq0Rpy0OTulT9LF+uvi4PhOUz7ZNeceA=";
  };

  patches = [
    # Fix boost 1.83+ compatibility
    # https://github.com/microsoft/LightGBM/issues/6786
    # Patch taken from https://github.com/conda-forge/lightgbm-feedstock/pull/69
    (fetchpatch {
      name = "fix-boost-sha1";
      url = "https://raw.githubusercontent.com/conda-forge/lightgbm-feedstock/68ca96d25d8a6f7281310a4ad3b8d5cdd01f067b/recipe/patches/0003-boost-sha1.patch";
      hash = "sha256-Hw2YmoduOPri7O1XV2p/3Ny4hC8xq7Jq4zoSuKhVeVQ=";
    })
  ];

  # Skip APPLE in favor of linux build for .so files
  postPatch = ''
    export PROJECT_SOURCE_DIR=./
    substituteInPlace CMakeLists.txt \
      --replace-fail "find_package(GTest CONFIG)" "find_package(GTest REQUIRED)" \
      --replace-fail "OpenCL_INCLUDE_DIRS}" "OpenCL_INCLUDE_DIRS}" \
      --replace-fail "elseif(APPLE)" "elseif(APPLESKIP)"
    substituteInPlace \
      external_libs/compute/include/boost/compute/cl.hpp \
      external_libs/compute/include/boost/compute/cl_ext.hpp \
      --replace-fail "include <OpenCL/" "include <CL/"
    substituteInPlace build_r.R \
      --replace-fail "shQuote(normalizePath" "shQuote(type = 'cmd', string = normalizePath" \
      --replace-fail "file.path(getwd(), \"lightgbm_r\")" "'$out/tmp'" \
      --replace-fail \
        "install_args <- c(\"CMD\", \"INSTALL\", \"--no-multiarch\", \"--with-keep.source\", tarball)" \
        "install_args <- c(\"CMD\", \"INSTALL\", \"--no-multiarch\", \"--with-keep.source\", \"-l $out/library\", tarball)"

    # Retry this test in next release. Something fails in the setup, so GTEST_FILTER is not enough
    substituteInPlace CMakeLists.txt \
      --replace-fail "tests/cpp_tests/test_arrow.cpp" ""
    rm tests/cpp_tests/test_arrow.cpp
  '';

  nativeBuildInputs = [
    cmake
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [ llvmPackages.openmp ]
  ++ lib.optionals openclSupport [
    opencl-headers
    ocl-icd
    boost
  ]
  ++ lib.optionals mpiSupport [ openmpi ]
  ++ lib.optionals hdfsSupport [ hadoop ]
  ++ lib.optionals (hdfsSupport || javaWrapper) [ openjdk ]
  ++ lib.optionals javaWrapper [ swig ]
  ++ lib.optionals rLibrary [
    R
    pandoc
  ];

  buildInputs = [ gtest ] ++ lib.optional cudaSupport cudaPackages.cudatoolkit;

  propagatedBuildInputs = lib.optionals rLibrary [
    rPackages.data_table
    rPackages.markdown
    rPackages.rmarkdown
    rPackages.jsonlite
    rPackages.Matrix
    rPackages.R6
  ];

  cmakeFlags =
    lib.optionals doCheck [
      (lib.cmakeBool "BUILD_CPP_TEST" true)
    ]
    ++ lib.optionals cudaSupport [
      (lib.cmakeBool "USE_CUDA" true)
      (lib.cmakeFeature "CMAKE_CXX_COMPILER" (lib.getExe cudaPackages.backendStdenv.cc))
    ]
    ++ lib.optionals openclSupport [
      (lib.cmakeBool "USE_GPU" true)
    ]
    ++ lib.optionals mpiSupport [
      (lib.cmakeBool "USE_MPI" true)
    ]
    ++ lib.optionals hdfsSupport [
      (lib.cmakeBool "USE_HDFS" true)
      (lib.cmakeFeature "HDFS_LIB" "${hadoop}/lib/hadoop-${hadoop.version}/lib/native/libhdfs.so")
      (lib.cmakeFeature "HDFS_INCLUDE_DIR" "${hadoop}/lib/hadoop-${hadoop.version}/include")
    ]
    ++ lib.optionals javaWrapper [
      (lib.cmakeBool "USE_SWIG" true)
      # RPATH of binary /nix/store/.../bin/... contains a forbidden reference to /build/
      (lib.cmakeBool "CMAKE_SKIP_BUILD_RPATH" true)
    ]
    ++ lib.optionals rLibrary [
      (lib.cmakeBool "__BUILD_FOR_R" true)
    ]
    ++ lib.optionals pythonLibrary [
      (lib.cmakeBool "__BUILD_FOR_PYTHON" true)
    ];

  configurePhase = lib.optionals rLibrary ''
    export R_LIBS_SITE="$out/library:$R_LIBS_SITE''${R_LIBS_SITE:+:}"
  '';

  # set the R package buildPhase to null because lightgbm has a
  # custom builder script that builds and installs in one step
  buildPhase = lib.optionals rLibrary '''';

  inherit doCheck;

  installPhase = ''
    runHook preInstall
  ''
  + lib.optionalString (!rLibrary) ''
    mkdir -p $out
    mkdir -p $out/lib
    mkdir -p $out/bin
    cp -r ../include $out
    install -Dm755 ../lib_lightgbm${stdenv.hostPlatform.extensions.sharedLibrary} $out/lib/lib_lightgbm${stdenv.hostPlatform.extensions.sharedLibrary}
  ''
  + lib.optionalString (!rLibrary && !pythonLibrary) ''
    install -Dm755 ../lightgbm $out/bin/lightgbm
  ''
  + lib.optionalString javaWrapper ''
    cp -r java $out
    cp -r com $out
    cp -r lightgbmlib.jar $out
  ''
  + ''''
  + lib.optionalString rLibrary ''
    mkdir $out
    mkdir $out/tmp
    mkdir $out/library
    mkdir $out/library/lightgbm
  ''
  + lib.optionalString (rLibrary && (!openclSupport)) ''
    Rscript build_r.R \
      -j$NIX_BUILD_CORES
    rm -rf $out/tmp
  ''
  + lib.optionalString (rLibrary && openclSupport) ''
    Rscript build_r.R --use-gpu \
      --opencl-library=${ocl-icd}/lib/libOpenCL.so \
      --opencl-include-dir=${opencl-headers}/include \
      --boost-librarydir=${boost} \
      -j$NIX_BUILD_CORES
    rm -rf $out/tmp
  ''
  + ''
    runHook postInstall
  '';

  postFixup = lib.optionalString rLibrary ''
    if test -e $out/nix-support/propagated-build-inputs; then
      ln -s $out/nix-support/propagated-build-inputs $out/nix-support/propagated-user-env-packages
    fi
  '';

  passthru = {
    tests = {
      pythonPackage = python3Packages.lightgbm;
    };
  };

  meta = {
    description = "Gradient boosting framework that uses tree based learning algorithms";
    mainProgram = "lightgbm";
    homepage = "https://github.com/microsoft/LightGBM";
    changelog = "https://github.com/microsoft/LightGBM/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ nviets ];
  };
})
