{
  lib,
  fetchFromGitHub,
  jq,
  python3,
  python3Packages,
  enableContrib ? true,
  enableCuda ? false,
  apply_patch_py,
  sysprof,
  libsysprof-capture,
  ...
}:
let
  inherit (lib.strings) cmakeBool;
in
(python3Packages.opencv4.override {
  inherit enableContrib;
  # Explanation: match CMAKE_OPENCV_IMG_CODER_SELECTION in evision/Makefile
  enableEXR = true;
  enableJPEG = true;
  enableJPEG2000 = true;
  enablePNG = true;
  enableTIFF = true;
  enableWebP = true;
}).overrideAttrs
  (
    finalAttrs: previousAttrs: {
      # Explanation: match evision-0.2.17's `OPENCV_VER`
      version = "4.13.0";

      src = fetchFromGitHub {
        owner = "opencv";
        repo = "opencv";
        tag = finalAttrs.version;
        hash = "sha256-h9gpSf+xf/OafQSCYq3JYBt/ShnxafSG7WbxesTjM/A=";
      };

      # Explanation: nixos-26.05#opencv4's contribSrc's version
      # is not using finalAttrs.version
      # so override postUnpack with the correct one.
      opencvContribSrc = fetchFromGitHub {
        owner = "opencv";
        repo = "opencv_contrib";
        tag = finalAttrs.version;
        hash = "sha256-8YRCq1H9afb1a0pVevH0x61SMW4dTpLAno/P9A6bOIg=";
      };
      postUnpack = ''
        cp --no-preserve=mode -r "${finalAttrs.opencvContribSrc}/modules" "$sourceRoot/opencv_contrib"
        # Required for apply_patch to find `opencv_contrib`,
        # eg. for `patch_ocr_tesseract_run_with_components`
        mkdir $sourceRoot/opencv_contrib-${finalAttrs.version}
        ln -s ../opencv_contrib $sourceRoot/opencv_contrib-${finalAttrs.version}/modules
      '';

      nativeBuildInputs = previousAttrs.nativeBuildInputs or [ ] ++ [
        jq
        python3
      ];
      buildInputs = previousAttrs.buildInputs or [ ] ++ [
        sysprof
        libsysprof-capture
      ];

      # Explanation(compatibility): evision has an unusual way to patch opencv:
      # a Python script.
      postPatch = ''
        python3 ${apply_patch_py} . ${finalAttrs.version}
      '';

      cmakeFlags =
        previousAttrs.cmakeFlags
        ++ [
          (cmakeBool "BUILD_EXAMPLES" false)
          (cmakeBool "INSTALL_C_EXAMPLES" false)

          # Explanation: from evision/mix.exs:@module_configuration
          (cmakeBool "BUILD_opencv_calib3d" true)
          (cmakeBool "BUILD_opencv_core" true)
          (cmakeBool "BUILD_opencv_dnn" true)
          (cmakeBool "BUILD_opencv_features2d" true)
          (cmakeBool "BUILD_opencv_flann" true)
          (cmakeBool "BUILD_opencv_highgui" true)
          (cmakeBool "BUILD_opencv_imgcodecs" true)
          (cmakeBool "BUILD_opencv_imgproc" true)
          (cmakeBool "BUILD_opencv_ml" true)
          (cmakeBool "BUILD_opencv_photo" true)
          (cmakeBool "BUILD_opencv_stitching" true)
          (cmakeBool "BUILD_opencv_ts" true)
          (cmakeBool "BUILD_opencv_video" true)
          (cmakeBool "BUILD_opencv_videoio" true)

          # Explanation: from evision/mix.exs:@module_configuration
          (cmakeBool "BUILD_opencv_gapi" false)
          (cmakeBool "BUILD_opencv_world" false)
          (cmakeBool "BUILD_opencv_python2" false)
          (cmakeBool "BUILD_opencv_python3" false)
          (cmakeBool "BUILD_opencv_java" false)

          # Explanation: from evision/Makefile:CMAKE_OPENCV_IMG_CODER_SELECTION
          (cmakeBool "BUILD_JASPER" true)
          # Explanation: from evision/Makefile
          (cmakeBool "BUILD_opencv_apps" false)
        ]
        ++ lib.optionals enableContrib [
          # Explanation: from evision/Makefile
          (cmakeBool "BUILD_opencv_freetype" false)
          (cmakeBool "BUILD_opencv_hdf" false)

          # Explanation: from evision/mix.exs:@module_configuration
          (cmakeBool "BUILD_opencv_aruco" true)
          (cmakeBool "BUILD_opencv_barcode" true)
          (cmakeBool "BUILD_opencv_bgsegm" true)
          (cmakeBool "BUILD_opencv_bioinspired" true)
          (cmakeBool "BUILD_opencv_dnn_superres" true)
          (cmakeBool "BUILD_opencv_face" true)
          (cmakeBool "BUILD_opencv_hfs" true)
          (cmakeBool "BUILD_opencv_img_hash" true)
          (cmakeBool "BUILD_opencv_line_descriptor" true)
          (cmakeBool "BUILD_opencv_mcc" true)
          (cmakeBool "BUILD_opencv_plot" true)
          (cmakeBool "BUILD_opencv_quality" true)
          (cmakeBool "BUILD_opencv_rapid" true)
          (cmakeBool "BUILD_opencv_reg" true)
          (cmakeBool "BUILD_opencv_rgbd" true)
          (cmakeBool "BUILD_opencv_saliency" true)
          (cmakeBool "BUILD_opencv_shape" true)
          (cmakeBool "BUILD_opencv_stereo" true)
          (cmakeBool "BUILD_opencv_structured_light" true)
          (cmakeBool "BUILD_opencv_surface_matching" true)
          (cmakeBool "BUILD_opencv_text" true)
          (cmakeBool "BUILD_opencv_tracking" true)
          (cmakeBool "BUILD_opencv_wechat_qrcode" true) # Disabled on ios or xros
          (cmakeBool "BUILD_opencv_xfeatures2d" true)
          (cmakeBool "BUILD_opencv_ximgproc" true)
          (cmakeBool "BUILD_opencv_xphoto" true)

          # Explanation: from evision/mix.exs:@module_configuration
          (cmakeBool "BUILD_opencv_datasets" false)
          (cmakeBool "BUILD_opencv_dnn_objdetect" false)
          (cmakeBool "BUILD_opencv_dpm" false)
          (cmakeBool "BUILD_opencv_optflow" false)
          (cmakeBool "BUILD_opencv_sfm" false)
          (cmakeBool "BUILD_opencv_videostab" false)
          (cmakeBool "BUILD_opencv_xobjdetect" false)
        ]
        ++ lib.optionals enableCuda [
          # Explanation: from evision/mix.exs:@module_configuration
          (cmakeBool "BUILD_opencv_cudaarithm" false)
          (cmakeBool "BUILD_opencv_cudabgsegm" false)
          (cmakeBool "BUILD_opencv_cudacodec" false)
          (cmakeBool "BUILD_opencv_cudafeatures2d" false)
          (cmakeBool "BUILD_opencv_cudafilters" false)
          (cmakeBool "BUILD_opencv_cudaimgproc" false)
          (cmakeBool "BUILD_opencv_cudalegacy" false)
          (cmakeBool "BUILD_opencv_cudaobjdetect" false)
          (cmakeBool "BUILD_opencv_cudaoptflow" false)
          (cmakeBool "BUILD_opencv_cudastereo" false)
          (cmakeBool "BUILD_opencv_cudawarping" false)
          (cmakeBool "BUILD_opencv_cudev" false)
        ];

      pythonImportsCheck = [
        # Explanation: fail with enabled modules.
        # ImportError: OpenCV loader: missing configuration file: ['config-3.13.py', 'config-3.py']. Check OpenCV installation.
        #"cv2"
        # Explanation: when enableContrib,
        # SfM is disabled in cmakeFlags (using BUILD_opencv_sfm).
        #"cv2.sfm"
      ];

      # Explanation(compatibility):
      # > [evision] uses and modifies gen2.py and hdr_parser.py
      # > from the python module in the OpenCV repo so that they output header files
      # > that can be used in Elixir bindings
      #
      # For that evision needs a gen_python_config.json generated for Python
      # listing the .hpp files to consider.
      # Unfortunately those files are absolute path in $NIX_BUILD_TOP,
      # they need to be fixed to point to somewhere in $out.
      # Note that $out/include/ cannot be used reliably
      # since some headers are not installed at all yet required by evision.
      postInstall = previousAttrs.postInstall or "" + ''
        pushd "$NIX_BUILD_TOP/$sourceRoot"
        find . \( -name "*.hpp" -or -name "*.h" \) \
             -exec sh -xc 'install -Dm644 -t$out/source/''${1%/*} $1' -- {} \;
        OPENCV_HEADERS="build/modules/python_bindings_generator/gen_python_config.json"
        mkdir -p $out/modules/python_bindings_generator/
        jq '.headers |= map(sub("^'"$NIX_BUILD_TOP"'"; "'$out'"))' \
          <"$OPENCV_HEADERS" \
          >$out/modules/python_bindings_generator/gen_python_config${lib.optionalString enableContrib "-contrib"}.json
        popd
      '';
    }
  )
