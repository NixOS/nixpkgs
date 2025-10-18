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
  ];

  nativeBuildInputs = [
    cmake
    ninja
    pkg-config
    libjpeg
    gtest
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
