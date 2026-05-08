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
    (lib.cmakeBool "BUILD_SHARED_LIBS" (!stdenv.hostPlatform.isStatic))
    (lib.cmakeBool "MZ_OPENSSL" true)
    (lib.cmakeBool "MZ_LIBCOMP" false) # builds only on Darwin by default where it fails due to mising headers
    (lib.cmakeBool "MZ_BUILD_TESTS" finalAttrs.doCheck)
    (lib.cmakeBool "MZ_BUILD_UNIT_TESTS" finalAttrs.doCheck)
    (lib.cmakeFeature "MZ_LIB_SUFFIX" "-ng")
  ]
  ++ lib.optionals stdenv.hostPlatform.isi686 [
    # tests fail
    (lib.cmakeBool "MZ_PKCRYPT" false)
  ];

  env.NIX_CFLAGS_COMPILE = lib.optionalString stdenv.hostPlatform.isDarwin "-Wno-register";

  postInstall = ''
    # make lib findable as libminizip-ng even if compat is enabled
    for ext in so dylib a ; do
      if [ -e $out/lib/libminizip.$ext ] && [ ! -e $out/lib/libminizip-ng.$ext ]; then
        ln -s $out/lib/libminizip.$ext $out/lib/libminizip-ng.$ext
      fi
    done
    if [ ! -e $out/include/minizip-ng ]; then
      ln -s $out/include $out/include/minizip-ng
    fi
  '';

  doCheck = stdenv.buildPlatform.canExecute stdenv.hostPlatform;
  nativeCheckInputs = [ gtest ];
  enableParallelChecking = false;

  meta = {
    description = "Fork of the popular zip manipulation library found in the zlib distribution";
    homepage = "https://github.com/zlib-ng/minizip-ng";
    license = lib.licenses.zlib;
    maintainers = with lib.maintainers; [
      ris
    ];
    platforms = lib.platforms.unix;
  };
})
