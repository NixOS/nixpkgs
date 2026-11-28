{
  lib,
  stdenv,
  fetchFromCodeberg,
  fetchpatch,
  cmake,
  gitUpdater,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libmixed";
  version = "2.4.1";

  src = fetchFromCodeberg {
    owner = "shirakumo";
    repo = "libmixed";
    tag = finalAttrs.version;
    hash = "sha256-eevMZt2w4+asFJNd/mMDXHTXUufqCnl7XoiWMHKifJI=";
  };

  patches = [
    # Fix build on Darwin, which has no malloc.h
    (fetchpatch {
      url = "https://codeberg.org/shirakumo/libmixed/commit/269dec7e8be293ff91d4ab460afbeba8f638b7f6.patch";
      hash = "sha256-AoKxeEvduapyc6ncBEtoXSy2G1DQc/kGa0O+dYADcWI=";
    })
    (fetchpatch {
      url = "https://codeberg.org/shirakumo/libmixed/commit/a06371078415c54b45a3f4b57fd9187579647157.patch";
      includes = [ "CMakeLists.txt" ];
      hash = "sha256-CUTBqW1DsbVlWvltgbbr9BcKGjQFRdVpq0Eh+PHcfUk=";
    })
    (fetchpatch {
      url = "https://codeberg.org/shirakumo/libmixed/commit/bd124ac136ad9bc17c165298ccc94d6107b6d89f.patch";
      hash = "sha256-gnD1J7IB8R8+KX9aWpZk66zbO7jrT/d/o5XBfRft2v4=";
    })
    # Fix undefined behavior in mixed_to_int32 and mixed_to_uint32
    ./fix-int32-conversion.patch
  ];

  outputs = [
    "out"
    "dev"
  ];

  strictDeps = true;
  __structuredAttrs = true;

  nativeBuildInputs = [ cmake ];

  cmakeFlags = [
    # Shared library and tests only; examples and docs need extra dependencies
    (lib.cmakeBool "BUILD_STATIC" false)
    (lib.cmakeBool "BUILD_EXAMPLES" false)
    (lib.cmakeBool "BUILD_DOCS" false)
    (lib.cmakeBool "BUILD_TESTER" finalAttrs.finalPackage.doCheck)
    # Upstream requires SSE3 by default, which the x86_64 baseline lacks
    (lib.cmakeBool "BUILD_SIMD" stdenv.hostPlatform.sse3Support)
  ];

  doCheck = true;
  checkTarget = "run_tests";

  # Codeberg releases lag behind tags and include -ci builds
  passthru.updateScript = gitUpdater { allowedVersions = "^[0-9.]+$"; };

  meta = {
    description = "Low-level audio mixer pipeline library";
    homepage = "https://shirakumo.org/docs/libmixed/";
    license = with lib.licenses; [
      zlib
      # Bundled libsamplerate
      bsd2
      # Bundled pffft
      bsd3
    ];
    maintainers = with lib.maintainers; [ yiyu ];
    platforms = lib.platforms.unix;
  };
})
