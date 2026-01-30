{
  lib,
  stdenv,
  llvmPackages,
  fetchFromGitHub,
  cmake,
  flatbuffers,
  libffi,
  libpng,
  libjpeg,
  libgbm,
  libGL,
  eigen,
  openblas,
  blas,
  lapack,
  removeReferencesTo,
  ninja,
  pythonSupport ? false,
  python3Packages,
  wasmSupport ? false,
  wabt,
  doCheck ? true,
  ctestCheckHook,
}:

assert blas.implementation == "openblas" && lapack.implementation == "openblas";

stdenv.mkDerivation (finalAttrs: {
  pname = "halide";
  version = "21.0.0";

  src = fetchFromGitHub {
    owner = "halide";
    repo = "Halide";
    tag = "v${finalAttrs.version}";
    hash = "sha256-A5EnZgXc9+L+bzWHftaL74nHmP8Jf0rnT5KJAAWvKis=";
  };

  postPatch = ''
    substituteInPlace src/runtime/CMakeLists.txt --replace-fail \
        '-isystem "''${VulkanHeaders_INCLUDE_DIR}"' \
        '-isystem "''${VulkanHeaders_INCLUDE_DIR}"
         -isystem "${llvmPackages.clang}/resource-root/include"'
  ''
  # Upstream Halide include a check in their CMake files that forces Halide to
  # link LLVM dynamically because of WebAssembly. It unnecessarily increases
  # the closure size in cases when the WebAssembly target is not used. Hence,
  # the following hack
  + lib.optionalString (!wasmSupport) ''
    substituteInPlace cmake/FindHalide_LLVM.cmake --replace-fail \
        'if (comp STREQUAL "WebAssembly")' \
        'if (FALSE)'
  '';

  cmakeFlags = [
    (lib.cmakeBool "WITH_PYTHON_BINDINGS" pythonSupport)
    (lib.cmakeBool "WITH_TESTS" doCheck)
    (lib.cmakeBool "WITH_TUTORIALS" doCheck)
    # Disable performance tests since they may fail on busy machines
    (lib.cmakeBool "WITH_TEST_PERFORMANCE" false)
    # Disable fuzzing tests -- this has become the default upstream after the
    # v16 release (See https://github.com/halide/Halide/commit/09c5d1d19ec8e6280ccbc01a8a12decfb27226ba)
    # These tests also fail to compile on Darwin because of some missing command line options...
    (lib.cmakeBool "WITH_TEST_FUZZ" false)
    # Disable FetchContent and use versions from nixpkgs instead
    (lib.cmakeBool "Halide_USE_FETCHCONTENT" false)
    (lib.cmakeFeature "Halide_WASM_BACKEND" (if wasmSupport then "wabt" else "OFF"))
    (lib.cmakeBool "Halide_LLVM_SHARED_LIBS" wasmSupport)
  ];

  outputs = [
    "out"
    "lib"
  ];

  inherit doCheck;

  disabledTests = [
    # Requires too much parallelism for remote builders.
    "mullapudi2016_fibonacci"
    # Tests performance---flaky in CI
    "mullapudi2016_reorder"
    # Take too long---we don't want to run these in CI.
    "adams2019_test_apps_autoscheduler"
    "anderson2021_test_apps_autoscheduler"
    "correctness_cross_compilation"
    "correctness_simd_op_check_hvx"
  ]
  ++ lib.optionals (stdenv.hostPlatform.isLinux && stdenv.hostPlatform.isAarch64) [
    # Failed  Required regular expression not found
    "mullapudi2016_histogram"
  ];

  dontUseNinjaCheck = true;
  nativeCheckInputs = [ ctestCheckHook ];

  postInstall =
    lib.optionalString pythonSupport ''
      mkdir -p $lib/lib/${python3Packages.python.libPrefix}
      mv -v $lib/lib/python3/site-packages $lib/lib/${python3Packages.python.libPrefix}
      rmdir $lib/lib/python3/
    ''
    # Debug symbols in the runtime include references to clang, but they're not
    # required for running the code. llvmPackages.clang increases the runtime
    # closure by at least a GB which is a waste, so we remove references to clang.
    + lib.optionalString (stdenv != llvmPackages.stdenv) ''
      remove-references-to -t ${llvmPackages.clang} $lib/lib/libHalide*
    '';

  # Note: only openblas and not atlas part of this Nix expression
  # see pkgs/development/libraries/science/math/liblapack/3.5.0.nix
  # to get a hint howto setup atlas instead of openblas
  buildInputs = [
    llvmPackages.llvm
    llvmPackages.lld
    llvmPackages.openmp
    llvmPackages.libclang
    libffi
    libpng
    libjpeg
    eigen
    openblas
  ]
  ++ lib.optionals (!stdenv.hostPlatform.isDarwin) [
    libgbm
    libGL
  ]
  ++ lib.optionals wasmSupport [ wabt ];

  nativeBuildInputs = [
    cmake
    flatbuffers
    removeReferencesTo
    ninja
  ]
  ++ lib.optionals pythonSupport [
    python3Packages.python
    python3Packages.pybind11
  ];

  propagatedBuildInputs = lib.optionals pythonSupport [
    python3Packages.numpy
    python3Packages.imageio
  ];

  meta = {
    description = "C++ based language for image processing and computational photography";
    homepage = "https://halide-lang.org";
    changelog = "https://github.com/halide/Halide/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [
      ck3d
      atila
      twesterhout
    ];
    broken = !stdenv.buildPlatform.canExecute stdenv.hostPlatform;
    badPlatforms = [
      # Build fails on darwin:
      # FAILED: [code=133] test/autoschedulers/anderson2021/anderson2021_demo.h
      lib.systems.inspect.patterns.isDarwin
    ];
  };
})
