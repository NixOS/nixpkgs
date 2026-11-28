{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  testers,
  ctestCheckHook,

  static ? stdenv.hostPlatform.isStatic,

  lz4,
  zfp,
  zlib-ng,
  zstd,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "c-blosc2";
  version = "3.7.0";

  src = fetchFromGitHub {
    owner = "Blosc";
    repo = "c-blosc2";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-nNwCWOgE+W/RQ+ms/Ov6EQp7DnZXlnYOHJZZWizzWew=";
  };

  patches = [
    # Fix heap buffer overflow in the ZFP compressors when the compressed
    # stream is smaller than the input but larger than the output buffer
    ./zfp-check-output-size.patch
  ];

  # https://github.com/NixOS/nixpkgs/issues/144170
  postPatch = ''
    sed -i -E \
      -e '/^libdir[=]/clibdir=@CMAKE_INSTALL_FULL_LIBDIR@' \
      -e '/^includedir[=]/cincludedir=@CMAKE_INSTALL_FULL_INCLUDEDIR@' \
      blosc2.pc.in
  '';

  nativeBuildInputs = [ cmake ];

  propagatedBuildInputs = [
    lz4
    zfp
    zlib-ng
    zstd
  ];

  cmakeFlags = [
    "-DBUILD_STATIC=${if static then "ON" else "OFF"}"
    "-DBUILD_SHARED=${if static then "OFF" else "ON"}"

    "-DBLOSC_DEPENDENCY_MODE=EXTERNAL"

    "-DBUILD_EXAMPLES=OFF"
    "-DBUILD_BENCHMARKS=OFF"
    "-DBUILD_TESTS=${if finalAttrs.finalPackage.doCheck then "ON" else "OFF"}"
  ];

  doCheck = !static;
  # possibly https://github.com/Blosc/c-blosc2/issues/432
  enableParallelChecking = false;

  nativeCheckInputs = [
    ctestCheckHook
  ];
  disabledTests = lib.optionals (zfp.passthru.bitStreamWordSize != 64) [
    # This test only supports the default 64-bit bitstream word of zfp
    "test_plugin_test_zfp_rate_getitem_cells"
  ];

  passthru.tests = {
    pkg-config = testers.testMetaPkgConfig finalAttrs.finalPackage;
    cmake-config = testers.hasCmakeConfigModules {
      moduleNames = [ "Blosc2" ];
      package = finalAttrs.finalPackage;
    };
  };

  meta = {
    description = "Fast, compressed, persistent binary data store library for C";
    homepage = "https://www.blosc.org";
    changelog = "https://github.com/Blosc/c-blosc2/releases/tag/v${finalAttrs.version}";
    pkgConfigModules = [ "blosc2" ];
    license = lib.licenses.bsd3;
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [ ris ];
  };
})
