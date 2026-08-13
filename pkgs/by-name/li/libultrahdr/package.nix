{
  stdenv,
  lib,
  fetchFromGitHub,
  replaceVars,
  cmake,
  ninja,
  pkg-config,
  libjpeg,
  gtest,
  ctestCheckHook,
  versionCheckHook,
  testers,
}:

stdenv.mkDerivation (finalAttrs: {
  version = "2.0.2";
  pname = "libultrahdr";

  src = fetchFromGitHub {
    owner = "google";
    repo = "libultrahdr";
    rev = "v${finalAttrs.version}";
    hash = "sha256-vCa3ibxC0e+ohh50ZR+uh4QFRxJrX5MRkIsZM0vobVs=";
  };

  outputs = [
    "out"
    "dev"
  ];

  patches = [
    (replaceVars ./gtest.patch {
      GTEST_INCLUDE_DIRS = "${lib.getDev gtest}/include";
    })

    # Remove platform and architecture detection logic
    # Also drop arch-specific compile and optimization flags to ensure
    # packaging friendliness.
    # Based on https://github.com/google/libultrahdr/pull/383
    # modified to target 2.0.2 instead of main
    ./remove-platform-and-detection-logic.patch
  ];

  # CMake incorrect absolute include/lib paths: https://github.com/NixOS/nixpkgs/issues/144170
  postPatch = ''
    substituteInPlace cmake/libuhdr.pc.in \
      --replace-fail \
        'libdir=''${prefix}/@CMAKE_INSTALL_LIBDIR@' \
        'libdir=@CMAKE_INSTALL_FULL_LIBDIR@' \
      --replace-fail \
        'includedir=''${prefix}/@CMAKE_INSTALL_INCLUDEDIR@' \
        'includedir=@CMAKE_INSTALL_FULL_INCLUDEDIR@'
  '';

  # use sse2 for floating point math to fix tests
  env = lib.optionalAttrs stdenv.hostPlatform.isi686 {
    CFLAGS = "-mfpmath=sse -msse2";
    CXXFLAGS = "-mfpmath=sse -msse2";
  };

  cmakeFlags = [
    (lib.cmakeBool "UHDR_BUILD_TESTS" true)
    # v2.0.x gained optional HEIF/AVIF support via libheif, enabled by
    # default. libheif is not wired up here, so disable it explicitly to
    # get a deterministic build (otherwise upstream warns and silently
    # disables it) and to match pre-2.0 packaging.
    (lib.cmakeBool "UHDR_ENABLE_HEIF" false)
    # Build disables install target in cross-compilation mode so
    # cross-compilation would fail on NixOS. Force flag to false.
    # See https://github.com/google/libultrahdr/blob/v${finalAttrs.version}/CMakeLists.txt#L148
    (lib.cmakeBool "CMAKE_CROSSCOMPILING" false)
  ];

  nativeBuildInputs = [
    cmake
    ninja
    pkg-config
  ];

  buildInputs = [
    gtest
    libjpeg
  ];

  nativeCheckInputs = [
    ctestCheckHook
  ];

  doCheck = true;

  nativeInstallCheckInputs = [
    versionCheckHook
  ];

  doInstallCheck = true;

  passthru.tests = {
    pkg-config = testers.testMetaPkgConfig finalAttrs.finalPackage;
  };

  meta = {
    description = "Reference codec for the Ultra HDR format";
    longDescription = ''
      Ultra HDR is a true HDR image format, and is backcompatible. libultrahdr
      is the reference codec for the Ultra HDR format. The codecs that support
      the format can render the HDR intent of the image on HDR displays; other
      codecs can still decode and display the SDR intent of the image.
    '';
    homepage = "https://developer.android.com/media/platform/hdr-image-format";
    changelog = "https://github.com/google/libultrahdr/releases/tag/v${finalAttrs.version}";
    pkgConfigModules = [ "libuhdr" ];
    maintainers = with lib.maintainers; [
      yzx9
    ];
    platforms = lib.platforms.all;
    license = with lib.licenses; [
      asl20
    ];
    mainProgram = "ultrahdr_app";
  };
})
