{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  pkg-config,
  eigen,
  libgeotiff,
  libjpeg,
  libpng,
  libtiff,
  libwebp,
  openjpeg,
  zlib,
  common-updater-scripts,
  coreutils,
  gitMinimal,
  gnugrep,
  writeShellScript,
}:

let
  # Emgu CV builds OpenCV in its own tree: the root CMakeLists.txt pulls the
  # opencv submodule in with ADD_SUBDIRECTORY and Emgu.CV.Extern links against
  # the targets it defines, so the system opencv cannot be substituted here.
  # The submodule points at Emgu's fork, which carries their own patches. It is
  # pinned to the revision the tag below records; passthru.updateScript moves
  # the two together.
  opencv = fetchFromGitHub {
    owner = "emgucv";
    repo = "opencv";
    rev = "2b862f17fc625948d75840300a3837c4d0defa7a";
    hash = "sha256-/kJUplXlrVK0Vl/nWD6+lzrKxHC90FLI26RwXSIfPUk=";
  };
in
stdenv.mkDerivation (finalAttrs: {
  pname = "emgucv";
  version = "5.0.0";

  __structuredAttrs = true;
  strictDeps = true;

  src = fetchFromGitHub {
    owner = "emgucv";
    repo = "emgucv";
    tag = finalAttrs.version;
    hash = "sha256-Obhp4cMkgCBKKdU6e1Q3bxBn/MUaVSqhRfeNGEvzxq8=";
  };

  postUnpack = ''
    cp -rT ${opencv} source/opencv
    chmod -R u+w source/opencv
  '';

  postPatch = ''
    # Only the native library is built here, so the C# toolchain that the
    # managed assemblies need is not a configure-time requirement.
    substituteInPlace CMakeLists.txt \
      --replace-fail "FIND_PACKAGE(CSharp REQUIRED)" "FIND_PACKAGE(CSharp)"

    # Don't let the build look at which distribution the host runs. It probes
    # /etc/os-release, lsb_release and uname, and on Ubuntu or RHEL hosts
    # and moves the output directory somewhere else
    substituteInPlace cmake/modules/CheckPlatform.cmake \
      --replace-fail "IF (UNIX AND NOT APPLE)" \
        "IF (FALSE)"

    # OpenCV 5 dropped the legacy per-module umbrella headers.  EmguCV 5.0
    # still includes a few of their old paths in the native wrapper and its
    # smoke test.
    find Emgu.CV.Extern tests -type f -exec sed -i \
      -e 's#opencv2/core/core.hpp#opencv2/core.hpp#g' \
      -e 's#opencv2/imgproc/imgproc.hpp#opencv2/imgproc.hpp#g' \
      -e 's#opencv2/objdetect/objdetect.hpp#opencv2/objdetect.hpp#g' \
      -e 's#opencv2/features2d/features2d.hpp#opencv2/features2d.hpp#g' \
      -e 's#opencv2/highgui/highgui.hpp#opencv2/highgui.hpp#g' \
      -e 's#opencv2/photo/photo.hpp#opencv2/photo.hpp#g' \
      -e 's#opencv2/video/video.hpp#opencv2/video.hpp#g' \
      -e 's#opencv2/ml/ml.hpp#opencv2/ml.hpp#g' \
      -e 's#opencv2/calib3d/calib3d.hpp#opencv2/calib3d.hpp#g' \
      -e 's#opencv2/imgcodecs/imgcodecs.hpp#opencv2/imgcodecs.hpp#g' \
      -e 's#opencv2/videoio/videoio.hpp#opencv2/videoio.hpp#g' \
      -e 's#opencv2/dnn/dnn.hpp#opencv2/dnn.hpp#g' \
      {} +
  '';

  nativeBuildInputs = [
    cmake
    pkg-config
  ];

  buildInputs = [
    eigen
    libgeotiff
    libjpeg
    libpng
    libtiff
    libwebp
    openjpeg
    zlib
  ];

  # Follows platforms/ubuntu/24.04/cmake_configure's "mini" profile, the one
  # upstream publishes as the Emgu.CV.runtime.mini.* NuGet packages.
  cmakeFlags = [
    (lib.cmakeBool "BUILD_SHARED_LIBS" false)
    (lib.cmakeBool "CMAKE_POSITION_INDEPENDENT_CODE" true)
    (lib.cmakeFeature "CMAKE_CXX_STANDARD" "17")
    (lib.cmakeBool "EMGU_CV_WITH_FREETYPE" false)
    (lib.cmakeBool "EMGU_CV_WITH_TESSERACT" false)
    # Skip the managed assemblies, which are consumed from NuGet instead
    (lib.cmakeBool "EMGU_CV_BUILD" false)
    (lib.cmakeBool "EMGU_CV_EXAMPLE_BUILD" false)

    # mini profile
    # OpenCV 5's imgproc module requires geometry and flann.  These are part
    # of upstream's mini profile and provide the basic image operations the
    # wrapper exposes.
    (lib.cmakeBool "BUILD_opencv_flann" true)
    (lib.cmakeBool "BUILD_opencv_geometry" true)
    (lib.cmakeBool "BUILD_opencv_imgproc" true)
    (lib.cmakeBool "BUILD_opencv_dnn" false)
    (lib.cmakeBool "BUILD_opencv_features2d" false)
    (lib.cmakeBool "BUILD_opencv_gapi" false)
    (lib.cmakeBool "BUILD_opencv_ml" false)
    (lib.cmakeBool "BUILD_opencv_photo" false)
    (lib.cmakeBool "BUILD_opencv_video" false)

    (lib.cmakeBool "BUILD_DOCS" false)
    (lib.cmakeBool "BUILD_JAVA" false)
    (lib.cmakeBool "BUILD_PERF_TESTS" false)
    (lib.cmakeBool "BUILD_TESTS" false)
    (lib.cmakeBool "BUILD_opencv_apps" false)
    (lib.cmakeBool "BUILD_opencv_python2" false)
    (lib.cmakeBool "BUILD_opencv_python3" false)
    (lib.cmakeBool "BUILD_opencv_ts" false)

    # Link the image codecs from Nixpkgs rather than building OpenCV's vendored copies
    (lib.cmakeBool "BUILD_JPEG" false)
    (lib.cmakeBool "BUILD_OPENJPEG" false)
    (lib.cmakeBool "BUILD_PNG" false)
    (lib.cmakeBool "BUILD_TIFF" false)
    (lib.cmakeBool "BUILD_WEBP" false)
    (lib.cmakeBool "BUILD_ZLIB" false)
    (lib.cmakeBool "WITH_JPEG" true)
    (lib.cmakeBool "WITH_OPENJPEG" true)
    (lib.cmakeBool "WITH_PNG" true)
    (lib.cmakeBool "WITH_TIFF" true)
    (lib.cmakeBool "WITH_WEBP" true)
    (lib.cmakeBool "WITH_EIGEN" true)

    # OpenCV falls back to a vendored copy of Jasper when OpenJPEG is disabled.
    (lib.cmakeBool "WITH_JASPER" false)
    # Only used by the dnn module, which the mini profile leaves out
    (lib.cmakeBool "WITH_PROTOBUF" false)
    # Would be fetched during the build.
    (lib.cmakeBool "WITH_IPP" false)
    # No consumer of libcvextern.so goes through OpenCV's own capture or
    # window backends, so none of them are wired up.
    (lib.cmakeBool "WITH_1394" false)
    (lib.cmakeBool "WITH_FFMPEG" false)
    (lib.cmakeBool "WITH_GSTREAMER" false)
    (lib.cmakeBool "WITH_GTK" false)
    (lib.cmakeBool "WITH_LAPACK" false)
    (lib.cmakeBool "WITH_OPENEXR" false)
    (lib.cmakeBool "WITH_V4L" false)
    (lib.cmakeBool "WITH_CUDA" false)
  ];

  buildFlags = [ "cvextern" ];

  # The build writes into libs/, under a subdirectory named after the detected
  # target on some architectures, so look the artifacts up by name.
  doCheck = true;
  checkPhase = ''
    runHook preCheck

    make -j$NIX_BUILD_CORES cvextern_test
    "$(find ../libs -type f -name cvextern_test)"

    runHook postCheck
  '';

  installPhase = ''
    runHook preInstall

    install -Dm555 "$(find ../libs -type f -name libcvextern.so)" -t $out/lib

    runHook postInstall
  '';

  passthru = {
    # Exposed so that the update script can rewrite the pinned revision.
    opencvSrc = opencv;

    updateScript = writeShellScript "update-emgucv" ''
      set -euo pipefail

      export PATH="${
        lib.makeBinPath [
          common-updater-scripts
          coreutils
          gitMinimal
          gnugrep
        ]
      }:$PATH"

      repo=https://github.com/emgucv/emgucv.git

      # Upstream also carries one tag that is not a version number.
      version=$(
        git ls-remote --tags --sort v:refname --refs "$repo" |
          cut --delimiter=/ --fields=3 |
          grep --extended-regexp '^[0-9]+(\.[0-9]+)*$' |
          tail --lines=1
      )

      update-source-version emgucv "$version"

      checkout=$(mktemp --directory)
      trap 'rm -rf "$checkout"' EXIT
      git clone --quiet --filter=blob:none --no-checkout --depth 1 \
        --branch "$version" "$repo" "$checkout"

      oldRev=$(nix-instantiate --eval --strict -A emgucv.opencvSrc.rev | tr -d '"')
      newRev=$(git -C "$checkout" rev-parse HEAD:opencv)

      if [[ "$newRev" != "$oldRev" ]]; then
        update-source-version emgucv \
          --ignore-same-version \
          --source-key=opencvSrc \
          --rev="$newRev"
      fi
    '';
  };

  meta = {
    description = "Cross platform .NET wrapper for OpenCV";
    longDescription = ''
      Emgu CV is a .NET wrapper for OpenCV. This package provides only
      libcvextern.so, the native half of the wrapper; the managed assemblies
      are distributed as NuGet packages.
    '';
    homepage = "https://www.emgu.com/";
    changelog = "https://github.com/emgucv/emgucv/releases/tag/${finalAttrs.version}";
    # Dual licensed: GPL-3.0 for open source use, commercial otherwise.
    # OpenCV, statically linked in, is Apache-2.0.
    license = with lib.licenses; [
      gpl3Only
      asl20
    ];
    maintainers = with lib.maintainers; [ kanagawamarcos ];
    platforms = lib.platforms.linux;
  };
})
