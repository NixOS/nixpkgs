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
    rev = "156f87e379445f631f646ebb26b566114fa5074c";
    hash = "sha256-JftBAzHsnk3U+6PZhk0/Q+5E8KHLNaYx69R+SE+Lr8U=";
  };
in
stdenv.mkDerivation (finalAttrs: {
  pname = "emgucv";
  version = "4.13.0";

  __structuredAttrs = true;
  strictDeps = true;

  src = fetchFromGitHub {
    owner = "emgucv";
    repo = "emgucv";
    tag = finalAttrs.version;
    hash = "sha256-SDI+QWAK4bNtto4WkC7ii48MW9qlhJUdlfR50hhuk5Y=";
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
    # /etc/os-release, lsb_release and uname, and on Ubuntu or RHEL hosts that
    # turns the missing .NET SDK into a hard error and moves the output
    # directory, so the result would depend on the builder rather than the
    # inputs.
    substituteInPlace cmake/modules/CheckPlatform.cmake \
      --replace-fail "IF (UNIX AND NOT APPLE)" \
        "IF (FALSE) # Nixpkgs: the result must not depend on the build machine"
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
  # upstream publishes as the Emgu.CV.runtime.mini.* NuGet packages: OpenCV is
  # linked statically into libcvextern.so and the modules below are left out.
  cmakeFlags = [
    (lib.cmakeBool "BUILD_SHARED_LIBS" false)
    (lib.cmakeBool "CMAKE_POSITION_INDEPENDENT_CODE" true)
    (lib.cmakeFeature "CMAKE_CXX_STANDARD" "17")
    (lib.cmakeBool "EMGU_CV_WITH_FREETYPE" false)
    (lib.cmakeBool "EMGU_CV_WITH_TESSERACT" false)
    # Skip the managed assemblies, which are consumed from NuGet instead and
    # would need a .NET SDK with network access to build.
    (lib.cmakeBool "EMGU_CV_BUILD" false)
    (lib.cmakeBool "EMGU_CV_EXAMPLE_BUILD" false)

    # mini profile
    (lib.cmakeBool "BUILD_opencv_dnn" false)
    (lib.cmakeBool "BUILD_opencv_features2d" false)
    (lib.cmakeBool "BUILD_opencv_flann" false)
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

    # Link the image codecs from Nixpkgs rather than building OpenCV's
    # vendored copies, which is what the portable upstream binary does.
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
    # Only used by the dnn module, which the mini profile leaves out. Keeping
    # it on builds OpenCV's vendored protobuf for nothing.
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
  # Upstream's own smoke test exercises the vector and quaternion helpers,
  # matchTemplate and the UMat code path, and prints the OpenCV build
  # configuration.
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

      # The opencv submodule has to move along with the version, since
      # Emgu.CV.Extern is built against that tree. Read the revision the tag
      # records, without fetching the submodule itself.
      checkout=$(mktemp --directory)
      trap 'rm -rf "$checkout"' EXIT
      git clone --quiet --filter=blob:none --no-checkout --depth 1 \
        --branch "$version" "$repo" "$checkout"

      oldRev=$(nix-instantiate --eval --strict -A emgucv.opencvSrc.rev | tr -d '"')
      newRev=$(git -C "$checkout" rev-parse HEAD:opencv)

      # Only touch it when it actually moved: asking update-source-version to
      # replace a revision with itself leaves a bogus hash behind.
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
