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
  pname = "minizip-ng" + lib.optionalString enableCompat "-compat";
  version = "4.2.1";

  src = fetchFromGitHub {
    owner = "zlib-ng";
    repo = "minizip-ng";
    rev = finalAttrs.version;
    hash = "sha256-gpjM8Cqoe4kafXgl2wXhhCRx39WC94qJ1DIDyd2n0G8=";
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
    (lib.cmakeBool "BUILD_SHARED_LIBS" (!stdenv.hostPlatform.isStatic))
    (lib.cmakeBool "MZ_OPENSSL" true)
    (lib.cmakeBool "MZ_PPMD" false) # PPMD support requres internet access to make a git clone
    (lib.cmakeBool "MZ_LIBCOMP" false) # builds only on Darwin by default where it fails due to mising headers
    (lib.cmakeBool "MZ_BUILD_TESTS" finalAttrs.doCheck)
    (lib.cmakeBool "MZ_BUILD_UNIT_TESTS" finalAttrs.doCheck)
    (lib.cmakeBool "MZ_COMPAT" enableCompat)
  ]
  ++ lib.optionals stdenv.hostPlatform.isi686 [
    # tests fail
    (lib.cmakeBool "MZ_PKCRYPT" false)
  ];

  env.NIX_CFLAGS_COMPILE = lib.optionalString stdenv.hostPlatform.isDarwin "-Wno-register";

  doCheck = stdenv.buildPlatform.canExecute stdenv.hostPlatform;
  checkInputs = [ gtest ];
  enableParallelChecking = false;

  strictDeps = true;
  __structuredAttrs = true;

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
