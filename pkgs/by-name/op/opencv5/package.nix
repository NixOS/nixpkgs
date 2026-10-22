{
  lib,
  stdenv,
  fetchurl,
  fetchFromGitHub,
  fetchpatch,
  cmake,
  pkg-config,
  unzip,
  zlib,
  pcre2,
  hdf5,
  boost,
  glib,
  glog,
  gflags,
  protobuf,
  config,
  ocl-icd,
  opencv5,

  enableJPEG ? true,
  libjpeg,
  enablePNG ? true,
  libpng,
  enableTIFF ? true,
  libtiff,
  enableWebP ? true,
  libwebp,
  enableJpegXL ? true,
  libjxl,
  enableEXR ? !stdenv.hostPlatform.isDarwin,
  openexr,
  enableJPEG2000 ? true,
  openjpeg,
  enableEigen ? true,
  eigen,
  enableBlas ? true,
  blas,
  enableVA ? !stdenv.hostPlatform.isDarwin,
  libva,
  enableContrib ? true,

  enableCuda ? config.cudaSupport,
  enableCublas ? enableCuda,
  enableCudnn ? false, # NOTE: CUDNN has a large impact on closure size so we disable it by default
  enableCufft ? enableCuda,
  cudaPackages,
  nvidia-optical-flow-sdk,

  # TODO: LTO does not work.
  # https://github.com/NixOS/nixpkgs/issues/343123
  enableLto ? false,
  enableUnfree ? false,
  enableIpp ? false,
  enablePython ? false,
  python3Packages,
  enableGtk3 ? false,
  gtk3,
  enableVtk ? false,
  vtk,
  enableFfmpeg ? true,
  # FIXME: unpin once upstream has ffmpeg 9 support
  ffmpeg_8-headless,
  enableGStreamer ? true,
  elfutils,
  gst_all_1,
  orc,
  libunwind,
  zstd,
  enableTesseract ? false,
  tesseract,
  leptonica,
  enableTbb ? false,
  onetbb,
  enableOvis ? false,
  ogre,
  enableGPhoto2 ? false,
  libgphoto2,
  enableDC1394 ? false,
  libdc1394,
  enableDocs ? false,
  doxygen,
  graphviz-nox,

  runAccuracyTests ? true,
  runPerformanceTests ? false,
  # Modules to enable via BUILD_LIST to build a customized opencv.
  # An empty lists means this setting is omitted which matches upstreams default.
  enabledModules ? [ ],

  bzip2,
}@inputs:

let
  inherit (lib.attrsets) mapAttrsToList optionalAttrs;
  inherit (lib.lists) last optionals;
  inherit (lib.strings)
    cmakeBool
    cmakeFeature
    cmakeOptionType
    concatStrings
    concatStringsSep
    optionalString
    ;
  inherit (lib.trivial) flip;

  pythonPackages = python3Packages;

  version = "5.0.0";

  # It's necessary to consistently use backendStdenv when building with CUDA
  # support, otherwise we get libstdc++ errors downstream
  stdenv = throw "Use effectiveStdenv instead";
  effectiveStdenv = if enableCuda then cudaPackages.backendStdenv else inputs.stdenv;

  src = fetchFromGitHub {
    owner = "opencv";
    repo = "opencv";
    tag = version;
    hash = "sha256-fmMHLQ5IHDKztuIaetQj/deCl82pVYh+Dvp8G9Xb5bk=";
  };

  contribSrc = fetchFromGitHub {
    owner = "opencv";
    repo = "opencv_contrib";
    tag = version;
    hash = "sha256-+z8vIGofdQPnjh5D7A8TQWXwTGRwTxSUBo1W/RdpIE4=";
  };

  testDataSrc = fetchFromGitHub {
    owner = "opencv";
    repo = "opencv_extra";
    tag = version;
    hash = "sha256-7h1Hlz+dkX2Q15lMv32BFyogv9jZtfmvOMruAWH9rHQ=";
  };

  # Contrib must be built in order to enable Tesseract support:
  buildContrib = enableContrib || enableTesseract || enableOvis;

  # See opencv/3rdparty/ippicv/ippicv.cmake
  ippicv =
    let
      package =
        {
          x86_64-linux = {
            rev = "406d398c436d0465c8e53dd432d9ecd9301d5f4a";
            hash = "sha256-Zyp3s/IEWhBtKDS8mtqTSRaL2IQafHRdMcuvZwxt5n8=";
            name = "ippicv_2026.0.0_lnx_intel64_20260327_general.tgz";
            md5 = "9a3ee0c5c3c02102faa422d60bfd1f4a";
          };
          i686-linux = {
            rev = "7f55c0c26be418d494615afca15218566775c725";
            hash = "sha256-XbmS+FXUL8MAG7kawbDkb2XHG9R0DpPhiYhq/18eTnY=";
            name = "ippicv_2021.12.0_lnx_ia32_20240425_general.tgz";
            md5 = "85ffa2b9ed7802b93c23fa27b0097d36";
          };
          x86_64-darwin = {
            rev = "0cc4aa06bf2bef4b05d237c69a5a96b9cd0cb85a";
            hash = "sha256-/kHivOgCkY9YdcRRaVgytXal3ChE9xFfGAB0CfFO5ec=";
            name = "ippicv_2021.9.1_mac_intel64_20230919_general.tgz";
            md5 = "14f01c5a4780bfae9dde9b0aaf5e56fc";
          };
        }
        .${effectiveStdenv.hostPlatform.system}
          or (throw "ICV is not available for this platform (or not yet supported by this package)");
    in
    {
      src =
        fetchFromGitHub {
          owner = "opencv";
          repo = "opencv_3rdparty";
          inherit (package) rev hash;
        }
        + "/ippicv";
      files = {
        ${package.name} = package.md5;
      };
      dst = ".cache/ippicv";
    };

  # See opencv_contrib/modules/xfeatures2d/cmake/download_vgg.cmake
  vgg = {
    src = fetchFromGitHub {
      owner = "opencv";
      repo = "opencv_3rdparty";
      rev = "fccf7cd6a4b12079f73bbfb21745f9babcd4eb1d";
      hash = "sha256-fjdGM+CxV1QX7zmF2AiR9NDknrP2PjyaxtjT21BVLmU=";
    };
    files = {
      "vgg_generated_48.i" = "e8d0dcd54d1bcfdc29203d011a797179";
      "vgg_generated_64.i" = "7126a5d9a8884ebca5aea5d63d677225";
      "vgg_generated_80.i" = "7cd47228edec52b6d82f46511af325c5";
      "vgg_generated_120.i" = "151805e03568c9f490a5e3a872777b75";
    };
    dst = ".cache/xfeatures2d/vgg";
  };

  # See opencv_contrib/modules/xfeatures2d/cmake/download_boostdesc.cmake
  boostdesc = {
    src = fetchFromGitHub {
      owner = "opencv";
      repo = "opencv_3rdparty";
      rev = "34e4206aef44d50e6bbcd0ab06354b52e7466d26";
      hash = "sha256-wlgtkixogqjlQLU1kOWdMWJatG6x1X513/C9DXt40Y8=";
    };
    files = {
      "boostdesc_bgm.i" = "0ea90e7a8f3f7876d450e4149c97c74f";
      "boostdesc_bgm_bi.i" = "232c966b13651bd0e46a1497b0852191";
      "boostdesc_bgm_hd.i" = "324426a24fa56ad9c5b8e3e0b3e5303e";
      "boostdesc_binboost_064.i" = "202e1b3e9fec871b04da31f7f016679f";
      "boostdesc_binboost_128.i" = "98ea99d399965c03d555cef3ea502a0b";
      "boostdesc_binboost_256.i" = "e6dcfa9f647779eb1ce446a8d759b6ea";
      "boostdesc_lbgm.i" = "0ae0675534aa318d9668f2a179c2a052";
    };
    dst = ".cache/xfeatures2d/boostdesc";
  };

  # See opencv_contrib/modules/face/CMakeLists.txt
  face = {
    src = fetchFromGitHub {
      owner = "opencv";
      repo = "opencv_3rdparty";
      rev = "8afa57abc8229d611c4937165d20e2a2d9fc5a12";
      hash = "sha256-m9yF4kfmpRJybohdRwUTmboeU+SbZQ6F6gm32PDWNBg=";
    };
    files = {
      "face_landmark_model.dat" = "7505c44ca4eb54b4ab1e4777cb96ac05";
    };
    dst = ".cache/data";
  };

  # See opencv_contrib/modules/gapi/cmake/DownloadADE.cmake
  ade = rec {
    src = fetchurl {
      url = "https://github.com/opencv/ade/archive/${name}";
      hash = "sha256-O+Yshk3N2Lkl6S9qWxWnoDmBngSms88IiCfwjPLMB78=";
    };
    name = "v0.1.2e.zip";
    md5 = "962ce79e0b95591f226431f7b5f152cd";
    dst = ".cache/ade";
  };

  # See opencv/modules/imgproc/CMakeLists.txt
  unifont = {
    src = fetchFromGitHub {
      owner = "vpisarev";
      repo = "opencv_3rdparty";
      rev = "cc7d85179d69a704bee209aa37ce8a657f2f8b34";
      hash = "sha256-ET1LEJC2QOBcjTLZ9bdfmkffB38UwzmZTTxXdOpheGI=";
    };
    files = {
      "WenQuanYiMicroHei.ttf.gz" = "fb79cf5b4f4c89414f1233f14c2eb273";
    };
    dst = ".cache/unifont";
  };

  # See opencv_contrib/modules/wechat_qrcode/CMakeLists.txt
  wechat_qrcode = {
    src = fetchFromGitHub {
      owner = "opencv";
      repo = "opencv_3rdparty";
      rev = "a8b69ccc738421293254aec5ddb38bd523503252";
      hash = "sha256-/n6zHwf0Rdc4v9o4rmETzow/HTv+81DnHP+nL56XiTY=";
    };
    files = {
      "detect.caffemodel" = "238e2b2d6f3c18d6c3a30de0c31e23cf";
      "detect.prototxt" = "6fb4976b32695f9f5c6305c19f12537d";
      "sr.caffemodel" = "cbfcd60361a73beb8c583eea7e8e6664";
      "sr.prototxt" = "69db99927a70df953b471daaba03fbef";
    };
    dst = ".cache/wechat_qrcode";
  };

  # See opencv/cmake/OpenCVDownload.cmake
  installExtraFiles =
    {
      dst,
      files,
      src,
      ...
    }:
    ''
      mkdir -p "${dst}"
    ''
    + concatStrings (
      flip mapAttrsToList files (
        name: md5: ''
          ln -s "${src}/${name}" "${dst}/${md5}-${name}"
        ''
      )
    );
  installExtraFile =
    {
      dst,
      md5,
      name,
      src,
      ...
    }:
    ''
      mkdir -p "${dst}"
      ln -s "${src}" "${dst}/${md5}-${name}"
    '';

  withOpenblas = (enableBlas && blas.provider.pname == "openblas");
  #multithreaded openblas conflicts with opencv multithreading, which manifest itself in hung tests
  #https://github.com/OpenMathLib/OpenBLAS/wiki/Faq/4bded95e8dc8aadc70ce65267d1093ca7bdefc4c#multi-threaded
  openblas_ = blas.provider.override { singleThreaded = true; };

  inherit (cudaPackages.flags) cmakeCudaArchitecturesString cudaCapabilities;

in

effectiveStdenv.mkDerivation {
  pname = "opencv";
  inherit version src;

  outputs = [
    "out"
    "cxxdev"
  ]
  ++ optionals (runAccuracyTests || runPerformanceTests) [
    "package_tests"
  ];
  cudaPropagateToOutput = "cxxdev";

  strictDeps = true;
  __structuredAttrs = true;

  postUnpack = optionalString buildContrib ''
    cp --no-preserve=mode -r "${contribSrc}/modules" "$NIX_BUILD_TOP/${src.name}/opencv_contrib"
  '';

  patches = [
    ./0001-cmake-OpenCVUtils.cmake-invalidate-Nix-store-paths-b.patch
    # 5.0.0 dropped opencv-caffe.proto but still builds caffe_io.cpp, which
    # breaks PROTOBUF_UPDATE_FILES with the system protobuf
    (fetchpatch {
      name = "dnn-remove-caffe-protobuf-leftovers";
      url = "https://github.com/opencv/opencv/commit/f7ad23157f1b99b59bc9a706e9c7e4c8394947ac.patch";
      hash = "sha256-33mo5mPq/5/9zbA26493OJbTzFt99RcYZTM7OHNArXY=";
    })
  ];

  postPatch =
    # patch applies the renames in the dnn fix above to the old files
    ''
      mv modules/dnn/src/caffe/glog_emulator.hpp modules/dnn/src/glog_emulator.hpp
      mv modules/dnn/src/caffe/caffe_io.hpp modules/dnn/src/protobuf_io.hpp
      rmdir modules/dnn/src/caffe
    ''
    +
      # This prevents cmake from using libraries in impure paths (which
      # causes build failure on non NixOS)
      ''
        sed -i '/Add these standard paths to the search paths for FIND_LIBRARY/,/^\s*$/{d}' CMakeLists.txt
      ''
    # TODO
    + ''
      substituteInPlace modules/ts/include/opencv2/ts/ts_gtest.h \
        --replace-fail \
          "#if defined(__GNUC__) && (__GNUC__ == 14)" \
          "#if defined(__GNUC__)"
    '';

  preConfigure =
    installExtraFiles unifont
    + optionalString enableIpp (installExtraFiles ippicv)
    + (optionalString buildContrib ''
      ${installExtraFile ade}
      appendToVar cmakeFlags "-DOPENCV_EXTRA_MODULES_PATH=$NIX_BUILD_TOP/${src.name}/opencv_contrib"

      ${installExtraFiles vgg}
      ${installExtraFiles boostdesc}
      ${installExtraFiles face}
      ${installExtraFiles wechat_qrcode}
    '');

  buildInputs = [
    boost
    gflags
    glib
    glog
    pcre2
    protobuf
    zlib
  ]
  ++ optionals enablePython [
    pythonPackages.python
  ]
  ++ optionals (effectiveStdenv.buildPlatform == effectiveStdenv.hostPlatform) [
    hdf5
  ]
  ++ optionals enableGtk3 [
    gtk3
  ]
  ++ optionals enableVtk [
    vtk
  ]
  ++ optionals enableJPEG [
    libjpeg
  ]
  ++ optionals enablePNG [
    libpng
  ]
  ++ optionals enableTIFF [
    libtiff
  ]
  ++ optionals enableWebP [
    libwebp
  ]
  ++ optionals enableJpegXL [
    libjxl
  ]
  ++ optionals enableEXR [
    openexr
  ]
  ++ optionals enableJPEG2000 [
    openjpeg
  ]
  ++ optionals enableFfmpeg [
    ffmpeg_8-headless
  ]
  ++ optionals (enableGStreamer && effectiveStdenv.hostPlatform.isLinux) [
    elfutils
    gst_all_1.gst-plugins-base
    gst_all_1.gst-plugins-good
    gst_all_1.gstreamer
    libunwind
    orc
    zstd
  ]
  ++ optionals enableOvis [
    ogre
  ]
  ++ optionals enableGPhoto2 [
    libgphoto2
  ]
  ++ optionals enableDC1394 [
    libdc1394
  ]
  ++ optionals enableEigen [
    eigen
  ]
  ++ optionals enableVA [
    libva
  ]
  ++ optionals enableBlas [
    blas.provider
  ]
  ++ optionals enableTesseract [
    # There is seemingly no compile-time flag for Tesseract.  It's
    # simply enabled automatically if contrib is built, and it detects
    # tesseract & leptonica.
    tesseract
    leptonica
  ]
  ++ optionals enableTbb [
    onetbb
  ]
  ++ optionals effectiveStdenv.hostPlatform.isDarwin [
    bzip2
  ]
  ++ optionals enableDocs [
    doxygen
    graphviz-nox
  ]
  ++ optionals enableCuda [
    cudaPackages.cuda_cudart
    cudaPackages.cccl # <thrust/*>
    cudaPackages.libnpp # npp.h
    nvidia-optical-flow-sdk
  ]
  ++ optionals enableCublas [
    # May start using the default $out instead once
    # https://github.com/NixOS/nixpkgs/issues/271792
    # has been addressed
    cudaPackages.libcublas # cublas_v2.h
  ]
  ++ optionals enableCudnn [
    cudaPackages.cudnn # cudnn.h
  ]
  ++ optionals enableCufft [
    cudaPackages.libcufft # cufft.h
  ];

  propagatedBuildInputs = optionals enablePython [ pythonPackages.numpy ];

  nativeBuildInputs = [
    cmake
    pkg-config
    protobuf
    unzip
  ]
  ++ optionals enablePython (
    [
      pythonPackages.python
      pythonPackages.numpy
      pythonPackages.pip
      pythonPackages.wheel
      pythonPackages.setuptools
    ]
    ++ optionals (effectiveStdenv.hostPlatform == effectiveStdenv.buildPlatform) [
      pythonPackages.pythonImportsCheckHook
    ]
  )
  ++ optionals enableCuda [
    cudaPackages.cuda_nvcc
  ];

  env = {
    # Configure can't find the library without this.
    OpenBLAS_HOME = optionalString withOpenblas openblas_.dev;
    OpenBLAS = optionalString withOpenblas openblas_;
  };

  cmakeFlags = [
    (cmakeBool "BUILD_INFO_SKIP_SYSTEM_VERSION" true)
    (cmakeBool "OPENCV_GENERATE_PKGCONFIG" true)
    (cmakeBool "WITH_OPENMP" true)
    (cmakeBool "BUILD_PROTOBUF" false)
    (cmakeFeature "CMAKE_CXX_STANDARD" "17") # required to enable protobuf
    (cmakeBool "WITH_PROTOBUF" true)
    (cmakeBool "PROTOBUF_UPDATE_FILES" true)
    (cmakeBool "OPENCV_ENABLE_NONFREE" enableUnfree)
    (cmakeBool "BUILD_TESTS" runAccuracyTests)
    (cmakeBool "BUILD_PERF_TESTS" runPerformanceTests)
    (cmakeBool "CMAKE_SKIP_BUILD_RPATH" true)
    (cmakeBool "BUILD_DOCS" enableDocs)
    # "OpenCV disables pkg-config to avoid using of host libraries. Consider using PKG_CONFIG_LIBDIR to specify target SYSROOT"
    # but we have proper separation of build and host libs :), fixes cross
    (cmakeBool "OPENCV_ENABLE_PKG_CONFIG" true)
    (cmakeBool "WITH_IPP" enableIpp)
    (cmakeBool "WITH_TIFF" enableTIFF)
    (cmakeBool "WITH_WEBP" enableWebP)
    (cmakeBool "WITH_JPEGXL" enableJpegXL)
    (cmakeBool "WITH_JPEG" enableJPEG)
    (cmakeBool "WITH_PNG" enablePNG)
    (cmakeBool "WITH_OPENEXR" enableEXR)
    (cmakeBool "WITH_OPENJPEG" enableJPEG2000)
    (cmakeBool "WITH_JASPER" false) # OpenCV falls back to a vendored copy of Jasper when OpenJPEG is disabled
    (cmakeBool "WITH_TBB" enableTbb)

    # CUDA options
    (cmakeBool "WITH_CUDA" enableCuda)
    (cmakeBool "WITH_CUBLAS" enableCublas)
    (cmakeBool "WITH_CUDNN" enableCudnn)
    (cmakeBool "WITH_CUFFT" enableCufft)

    # LTO options
    (cmakeBool "ENABLE_LTO" enableLto)
    (cmakeBool "ENABLE_THIN_LTO" (
      enableLto
      && (
        # Only clang supports thin LTO, so we must either be using clang through the effectiveStdenv,
        effectiveStdenv.cc.isClang
        ||
          # or through the backend effectiveStdenv.
          (enableCuda && effectiveStdenv.cc.isClang)
      )
    ))
  ]
  ++ optionals enableCuda [
    (cmakeBool "CUDA_FAST_MATH" true)
    (cmakeFeature "CUDA_NVCC_FLAGS" "--expt-relaxed-constexpr")

    # OpenCV respects at least three variables:
    # -DCUDA_GENERATION takes a single arch name, e.g. Volta
    # -DCUDA_ARCH_BIN takes a semicolon-separated list of real arches, e.g. "8.0;8.6"
    # -DCUDA_ARCH_PTX takes the virtual arch, e.g. "8.6"
    (cmakeFeature "CUDA_ARCH_BIN" cmakeCudaArchitecturesString)
    (cmakeFeature "CUDA_ARCH_PTX" (last cudaCapabilities))

    (cmakeOptionType "path" "NVIDIA_OPTICAL_FLOW_2_0_HEADERS_PATH" nvidia-optical-flow-sdk.outPath)
  ]
  ++ optionals effectiveStdenv.hostPlatform.isDarwin [
    (cmakeBool "WITH_OPENCL" false)
    (cmakeBool "WITH_LAPACK" false)

    # Disable unnecessary vendoring that's enabled by default only for Darwin.
    # Note that the opencvFlag feature flags listed above still take
    # precedence, so we can safely list everything here.
    (cmakeBool "BUILD_ZLIB" false)
    (cmakeBool "BUILD_TIFF" false)
    (cmakeBool "BUILD_OPENJPEG" false)
    (cmakeBool "BUILD_JASPER" false)
    (cmakeBool "BUILD_JPEG" false)
    (cmakeBool "BUILD_PNG" false)
    (cmakeBool "BUILD_WEBP" false)
  ]
  ++ optionals (!effectiveStdenv.hostPlatform.isDarwin) [
    (cmakeOptionType "path" "OPENCL_LIBRARY" "${ocl-icd}/lib/libOpenCL.so")
  ]
  ++ optionals enablePython [
    (cmakeOptionType "path" "OPENCV_PYTHON_INSTALL_PATH" pythonPackages.python.sitePackages)
  ]
  ++ optionals (enabledModules != [ ]) [
    (cmakeFeature "BUILD_LIST" (concatStringsSep "," enabledModules))
  ];

  postBuild = optionalString enableDocs ''
    make doxygen
  '';

  preInstall =
    optionalString (runAccuracyTests || runPerformanceTests) ''
      mkdir $package_tests
      cp -R $src/samples $package_tests/
    ''
    + optionalString runAccuracyTests ''
      mv ./bin/*test* $package_tests/
    ''
    + optionalString runPerformanceTests ''
      mv ./bin/*perf* $package_tests/
    '';

  # By default $out/lib/pkgconfig/opencv5.pc looks something like this:
  #
  #   prefix=/nix/store/g0wnfyjjh4rikkvp22cpkh41naa43i4i-opencv-4.0.0
  #   exec_prefix=${prefix}
  #   libdir=${exec_prefix}//nix/store/g0wnfyjjh4rikkvp22cpkh41naa43i4i-opencv-4.0.0/lib
  #   includedir_old=${prefix}//nix/store/g0wnfyjjh4rikkvp22cpkh41naa43i4i-opencv-4.0.0/include/opencv4/opencv
  #   includedir_new=${prefix}//nix/store/g0wnfyjjh4rikkvp22cpkh41naa43i4i-opencv-4.0.0/include/opencv4
  #   ...
  #   Libs: -L${exec_prefix}//nix/store/g0wnfyjjh4rikkvp22cpkh41naa43i4i-opencv-4.0.0/lib ...
  # Note that ${exec_prefix} is set to $out but that $out is also appended to
  # ${exec_prefix}. This causes linker errors in downstream packages so we strip
  # of $out after the ${exec_prefix} and ${prefix} prefixes:
  postInstall = ''
    sed -i "s|{exec_prefix}/$out|{exec_prefix}|;s|{prefix}/$out|{prefix}|" \
      "$out/lib/pkgconfig/opencv5.pc"
    mkdir "$cxxdev"
  ''
  # fix deps not propagating from opencv5.cxxdev if cuda is disabled
  # see https://github.com/NixOS/nixpkgs/issues/276691
  + optionalString (!enableCuda) ''
    mkdir -p "$cxxdev/nix-support"
    echo "''${!outputDev}" >> "$cxxdev/nix-support/propagated-build-inputs"
  ''
  # remove the requirement that the exact same version of CUDA is used in packages
  # consuming OpenCV's CMakes files
  + optionalString enableCuda ''
    substituteInPlace "$out/lib/cmake/opencv5/OpenCVConfig.cmake" \
      --replace-fail \
        'find_host_package(CUDA ''${OpenCV_CUDA_VERSION} EXACT REQUIRED)' \
        'find_host_package(CUDAToolkit REQUIRED)' \
      --replace-fail \
        'message(FATAL_ERROR "OpenCV static library was compiled with CUDA' \
        'message("OpenCV static library was compiled with CUDA'
  ''
  # install python distribution information, so other packages can `import opencv`
  + optionalString enablePython ''
    pushd $NIX_BUILD_TOP/$sourceRoot/modules/python/package
    python -m pip wheel --verbose --no-index --no-deps --no-clean --no-build-isolation --wheel-dir dist .

    pushd dist
    python -m pip install ./*.whl --no-index --no-warn-script-location --prefix="$out" --no-cache

    popd
    popd
  '';

  pythonImportsCheck = [
    "cv2"
    "cv2.sfm"
  ];

  passthru = {
    cudaSupport = enableCuda;

    tests =
      optionalAttrs (!effectiveStdenv.hostPlatform.isDarwin) {
        withIpp = opencv5.override { enableIpp = true; };
      }
      // optionalAttrs (!enablePython) {
        pythonEnabled = opencv5.override { enablePython = true; };
      };
  }
  // optionalAttrs enablePython { pythonPath = [ ]; };

  meta = {
    description = "Open Computer Vision Library with more than 500 algorithms";
    homepage = "https://opencv.org/";
    license = if enableUnfree then lib.licenses.unfree else lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ basvandijk ];
    platforms = lib.platforms.unix;
    # The CUDA patches of opencv4 don't apply yet
    broken = enableCuda;
  };
}
