{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  nasm,
  openjdk,
  enableJava ? false, # whether to build the java wrapper
  enableJpeg7 ? false, # whether to build libjpeg with v7 compatibility
  enableJpeg8 ? false, # whether to build libjpeg with v8 compatibility
  enableStatic ? stdenv.hostPlatform.isStatic,
  enableShared ? !stdenv.hostPlatform.isStatic,

  # for passthru.tests
  dvgrab,
  epeg,
  gd,
  graphicsmagick,
  imagemagick,
  imlib2,
  jhead,
  libjxl,
  mjpegtools,
  opencv,
  python3,
  vips,
  testers,
  nix-update-script,
}:

assert !(enableJpeg7 && enableJpeg8); # pick only one or none, not both

stdenv.mkDerivation (finalAttrs: {
  pname = "libjpeg-turbo";
  version = "3.1.2";

  src = fetchFromGitHub {
    owner = "libjpeg-turbo";
    repo = "libjpeg-turbo";
    tag = finalAttrs.version;
    hash = "sha256-tmeWLJxieV42f9ljSpKJoLER4QOYQLsLFC7jW54YZAk=";
  };

  patches =
    [ ]
    ++ lib.optionals stdenv.hostPlatform.isMinGW [
      ./mingw-boolean.patch
    ];

  outputs = [
    "bin"
    "dev"
    "out"
    "man"
    "doc"
  ];

  nativeBuildInputs = [
    cmake
    nasm
  ]
  ++ lib.optionals enableJava [
    openjdk
  ];

  cmakeFlags = [
    "-DENABLE_STATIC=${if enableStatic then "1" else "0"}"
    "-DENABLE_SHARED=${if enableShared then "1" else "0"}"
  ]
  ++ lib.optionals enableJava [
    "-DWITH_JAVA=1"
  ]
  ++ lib.optionals enableJpeg7 [
    "-DWITH_JPEG7=1"
  ]
  ++ lib.optionals enableJpeg8 [
    "-DWITH_JPEG8=1"
  ]
  ++ lib.optionals stdenv.hostPlatform.isRiscV [
    # https://github.com/libjpeg-turbo/libjpeg-turbo/issues/428
    # https://github.com/libjpeg-turbo/libjpeg-turbo/commit/88bf1d16786c74f76f2e4f6ec2873d092f577c75
    "-DFLOATTEST=fp-contract"
  ];

  doInstallCheck = true;
  installCheckTarget = "test";

  passthru = {
    updateScript = nix-update-script { };
    dev_private = throw "not supported anymore";
    tests = {
      inherit
        dvgrab
        epeg
        gd
        graphicsmagick
        imagemagick
        imlib2
        jhead
        libjxl
        mjpegtools
        opencv
        vips
        ;
      inherit (python3.pkgs) pillow imread pyturbojpeg;
      pkg-config = testers.testMetaPkgConfig finalAttrs.finalPackage;
    };
  };

  meta = {
    homepage = "https://libjpeg-turbo.org/";
    description = "Faster (using SIMD) libjpeg implementation";
    license = lib.licenses.ijg; # and some parts under other BSD-style licenses
    changelog = "https://github.com/libjpeg-turbo/libjpeg-turbo/releases/tag/${finalAttrs.version}";
    pkgConfigModules = [
      "libjpeg"
      "libturbojpeg"
    ];
    maintainers = with lib.maintainers; [
      vcunat
      kamadorueda
    ];
    platforms = lib.platforms.all;
  };
})
