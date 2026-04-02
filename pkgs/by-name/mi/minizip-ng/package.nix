{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  gtest,
  pkg-config,
  zlib,
  bzip2,
  xz,
  zstd,
  openssl,
  enableCompat ? false,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "minizip-ng";
  version = "4.1.0";

  src = fetchFromGitHub {
    owner = "zlib-ng";
    repo = "minizip-ng";
    rev = finalAttrs.version;
    hash = "sha256-H6ttsVBs437lWMBsq5baVDb9e5I6Fh+xggFre/hxGKU=";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
  ];

  buildInputs = [
    zlib
    bzip2
    xz
    zstd
    openssl
  ];

  cmakeFlags = [
    "-DBUILD_SHARED_LIBS=${if stdenv.hostPlatform.isStatic then "OFF" else "ON"}"
    "-DMZ_OPENSSL=ON"
    "-DMZ_BUILD_TESTS=${if finalAttrs.finalPackage.doCheck then "ON" else "OFF"}"
    "-DMZ_BUILD_UNIT_TESTS=${if finalAttrs.finalPackage.doCheck then "ON" else "OFF"}"
    "-DMZ_COMPAT=${if enableCompat then "ON" else "OFF"}"
  ]
  ++ lib.optionals stdenv.hostPlatform.isi686 [
    # tests fail
    "-DMZ_PKCRYPT=OFF"
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    # missing header file
    "-DMZ_LIBCOMP=OFF"
  ];

  env.NIX_CFLAGS_COMPILE = lib.optionalString stdenv.hostPlatform.isDarwin "-Wno-register";

  doCheck = stdenv.buildPlatform.canExecute stdenv.hostPlatform;
  nativeCheckInputs = [ gtest ];
  enableParallelChecking = false;

  meta = {
    description = "Fork of the popular zip manipulation library found in the zlib distribution";
    homepage = "https://github.com/zlib-ng/minizip-ng";
    license = lib.licenses.zlib;
    maintainers = with lib.maintainers; [
      ris
      kuflierl
    ];
    platforms = lib.platforms.unix;
  };
})
