{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch2,
  makeWrapper,
  cmake,
  python3Packages,
  mpi,
  mpiCheckPhaseHook,
  metis,
  opencascade-occt,
  libGLU,
  zlib,
  tcl,
  tk,
  xorg,
  libjpeg,
  ffmpeg,
  catch2,
  avxSupport ? stdenv.hostPlatform.avxSupport,
  avx2Support ? stdenv.hostPlatform.avx2Support,
  avx512Support ? stdenv.hostPlatform.avx512Support,
}:
let
  archFlags = toString (
    lib.optional avxSupport "-mavx"
    ++ lib.optional avx2Support "-mavx2"
    ++ lib.optional avx512Support "-mavx512"
  );
  patchSource = "https://salsa.debian.org/science-team/netgen/-/raw/debian/6.2.2404+dfsg1-5/debian/patches";
in
stdenv.mkDerivation (finalAttrs: {
  pname = "netgen";
  version = "6.2.2501";

  src = fetchFromGitHub {
    owner = "ngsolve";
    repo = "netgen";
    tag = "v${finalAttrs.version}";
    hash = "sha256-IzYulT3bo7XZiEEy8vNCct0zqHCnbQaH+y4fHMorzZw=";
  };

  patches = [
    # disable some platform specified code used by downstream ngsolve
    # can be enabled with -march=armv8.3-a+simd when compiling ngsolve
    # note compiling netgen itself is not influenced by this feature
    (fetchpatch2 {
      url = "https://github.com/NGSolve/netgen/pull/197/commits/1d93dfba00f224787cfc2cde1af2ab5d7f5b87f7.patch";
      hash = "sha256-3Nom4uGhGLtSGn/k+qKKSxVxrGtGTHqPtcNn3D/gkZU";
    })

    (fetchpatch2 {
      url = "${patchSource}/use-local-catch2.patch";
      hash = "sha256-h4ob8tl6mvGt5B0qXRFNcl9MxPXxRhYw+PrGr5iRGGk=";
    })
    (fetchpatch2 {
      url = "${patchSource}/ffmpeg_link_libraries.patch";
      hash = "sha256-S02OPH9hbJjOnBm6JMh6uM5XptcubV24vdyEF0FusoM=";
    })
    (fetchpatch2 {
      url = "${patchSource}/fix_nggui_tcl.patch";
      hash = "sha256-ODDT67+RWBzPhhq/equWsu78x9L/Yrs3U8VQ1Uu0zZw=";
    })
    (fetchpatch2 {
      url = "${patchSource}/include_stdlib.patch";
      hash = "sha256-W+NgGBuy/UmzVbPTSqR8FRUlyN/9dl9l9e9rxKklmIc=";
    })
    (fetchpatch2 {
      url = "${patchSource}/fix-version.patch";
      hash = "sha256-CT98Wq3UufB81z/jYLiH9nXvt+QzoZ7210OeuFXCfmc=";
    })
  ];

  # when generating python stub file utilizing system python pybind11_stubgen module
  # cmake need to inherit pythonpath
  postPatch = ''
    substituteInPlace python/CMakeLists.txt \
      --replace-fail ''\'''${CMAKE_INSTALL_PREFIX}/''${NG_INSTALL_DIR_PYTHON}' \
                     ''\'''${CMAKE_INSTALL_PREFIX}/''${NG_INSTALL_DIR_PYTHON}:$ENV{PYTHONPATH}'

    substituteInPlace ng/ng.tcl ng/onetcl.cpp \
      --replace-fail "libnggui" "$out/lib/libnggui"
  '';

  nativeBuildInputs = [
    cmake
    makeWrapper
    python3Packages.pybind11-stubgen
  ];

  buildInputs = [
    metis
    opencascade-occt
    zlib
    tcl
    tk
    libGLU
    xorg.libXmu
    libjpeg
    ffmpeg
    mpi
  ];

  propagatedBuildInputs = with python3Packages; [
    packaging
    pybind11
    mpi4py
    numpy
  ];

  cmakeFlags = [
    (lib.cmakeFeature "NETGEN_VERSION_GIT" "v${finalAttrs.version}-0")
    (lib.cmakeFeature "CMAKE_CXX_FLAGS" archFlags)
    (lib.cmakeBool "USE_MPI" true)
    (lib.cmakeBool "USE_MPI4PY" true)
    (lib.cmakeBool "PREFER_SYSTEM_PYBIND11" true)
    (lib.cmakeBool "BUILD_STUB_FILES" true)
    (lib.cmakeBool "USE_SUPERBUILD" false) # use system packages
    (lib.cmakeBool "USE_NATIVE_ARCH" false)
    (lib.cmakeBool "USE_JPEG" true)
    (lib.cmakeBool "USE_MPEG" true)
    (lib.cmakeBool "BUILD_TESTING" finalAttrs.finalPackage.doInstallCheck)
    (lib.cmakeBool "ENABLE_UNIT_TESTS" finalAttrs.finalPackage.doInstallCheck)
  ];

  # mesh generation differs on x86_64 and aarch64 platform
  # tests will fail on aarch64 platform
  doInstallCheck = stdenv.hostPlatform.isx86_64;

  preInstallCheck = ''
    export PYTHONPATH=$out/${python3Packages.python.sitePackages}:$PYTHONPATH
  '';

  installCheckTarget = "test";

  nativeInstallCheckInputs = [
    catch2
    python3Packages.pytest
    python3Packages.pytest-check
    python3Packages.pytest-mpi
    mpiCheckPhaseHook
  ];

  passthru = {
    inherit avxSupport avx2Support avx512Support;
  };

  meta = {
    homepage = "https://ngsolve.org";
    description = "Atomatic 3d tetrahedral mesh generator";
    license = with lib.licenses; [
      lgpl2Plus
      lgpl21Plus
      lgpl21Only
      bsd3
      boost
      publicDomain
    ];
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
    ];
    mainProgram = "netgen";
    maintainers = with lib.maintainers; [ qbisi ];
  };
})
