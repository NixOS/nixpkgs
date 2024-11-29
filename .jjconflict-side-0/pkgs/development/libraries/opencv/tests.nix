{ opencv4
, testDataSrc
, stdenv
, lib
, runCommand
, gst_all_1
, runAccuracyTests
, runPerformanceTests
, enableGStreamer
, enableGtk2
, enableGtk3
, xvfb-run
}:
let
  testNames = [
    "calib3d"
    "core"
    "features2d"
    "flann"
    "imgcodecs"
    "imgproc"
    "ml"
    "objdetect"
    "photo"
    "stitching"
    "video"
    #"videoio" # - a lot of GStreamer warnings and failed tests
    #"dnn" #- some caffe tests failed, probably because github workflow also downloads additional models
  ] ++ lib.optionals (!stdenv.hostPlatform.isAarch64 && enableGStreamer) [ "gapi" ]
  ++ lib.optionals (enableGtk2 || enableGtk3) [ "highgui" ];
  perfTestNames = [
    "calib3d"
    "core"
    "features2d"
    "imgcodecs"
    "imgproc"
    "objdetect"
    "photo"
    "stitching"
    "video"
  ] ++ lib.optionals (!stdenv.hostPlatform.isAarch64 && enableGStreamer) [ "gapi" ];
  testRunner = lib.optionalString (!stdenv.hostPlatform.isDarwin) "${lib.getExe xvfb-run} -a ";
  testsPreparation = ''
    touch $out
    # several tests want a write access, so we have to copy files
    tmpPath="$(mktemp -d "/tmp/opencv_extra_XXXXXX")"
    cp -R ${testDataSrc} $tmpPath/opencv_extra
    chmod -R +w $tmpPath/opencv_extra
    export OPENCV_TEST_DATA_PATH="$tmpPath/opencv_extra/testdata"
    export OPENCV_SAMPLES_DATA_PATH="${opencv4.package_tests}/samples/data"

    #ignored tests because of gtest error - "Test code is not available due to compilation error with GCC 11"
    export GTEST_FILTER="-AsyncAPICancelation/cancel*"
  '';
  accuracyTests = lib.optionalString runAccuracyTests ''
    ${ builtins.concatStringsSep "\n"
      (map (test: "${testRunner}${opencv4.package_tests}/opencv_test_${test} --test_threads=$NIX_BUILD_CORES --gtest_filter=$GTEST_FILTER" ) testNames)
    }
  '';
  performanceTests = lib.optionalString runPerformanceTests ''
    ${ builtins.concatStringsSep "\n"
      (map (test: "${testRunner}${opencv4.package_tests}/opencv_perf_${test} --perf_impl=plain --perf_min_samples=10 --perf_force_samples=10 --perf_verify_sanity --skip_unstable=1 --gtest_filter=$GTEST_FILTER") perfTestNames)
    }
  '';
in
runCommand "opencv4-tests"
{
  nativeBuildInputs = lib.optionals enableGStreamer (with gst_all_1; [ gstreamer gst-plugins-base gst-plugins-good ]);
}
  (testsPreparation + accuracyTests + performanceTests)
