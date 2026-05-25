{
  stdenv,
  lib,
  fetchFromGitHub,
  fetchpatch,
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
  version = "1.4.0";
  pname = "libultrahdr";

  src = fetchFromGitHub {
    owner = "google";
    repo = "libultrahdr";
    rev = "v${finalAttrs.version}";
    hash = "sha256-SLhHiwuyHzVx/Kv+eBy8LzHTnShKXlJoszxZNPATbhs=";
  };

  outputs = [
    "out"
    "dev"
  ];

  patches = [
    # Fix build with gcc 15 by adding missing cstdint header
    (fetchpatch {
      url = "https://github.com/google/libultrahdr/commit/5fa99b5271a3c80a13c78062d7adc6310222dd8e.patch";
      hash = "sha256-o6lbDOdx+ZrCy/Iq02WjM9Tas8C5P/FMwUtXMUCoZGY=";
    })

    (replaceVars ./gtest.patch {
      GTEST_INCLUDE_DIRS = "${lib.getDev gtest}/include";
    })
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

  cmakeFlags = [
    (lib.cmakeBool "UHDR_BUILD_TESTS" true)
    # Build disables install target in cross-compilation mode so
    # cross-compilation would fail on NixOS. Force flag to false.
    # See https://github.com/google/libultrahdr/blob/8cbc983d2f6c2171af5cbcdb8801102f83fe92ab/CMakeLists.txt#L153
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
