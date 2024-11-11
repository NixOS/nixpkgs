{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchDebianPatch,
  git,
  makeWrapper,
  cmake,
  python3,
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
stdenv.mkDerivation (finalAttrs: {
  pname = "netgen";
  version = "6.2.2405";

  src = fetchFromGitHub {
    owner = "ngsolve";
    repo = "netgen";
    rev = "v${finalAttrs.version}";
    hash = "sha256-y0Vol8vpccktiqOolRrAbw7JWF4o8Nh9t/fcDnBOWXE=";
  };

  patches = [
    # disable some platform specified code used by downstream ngsolve
    # can be enabled with -march=armv8.3-a+simd when compiling ngsolve
    # note compiling netgen itself is not affected by this patch
    ./option-arm-neon-complex.patch
    (fetchDebianPatch {
      inherit (finalAttrs) pname;
      version = "6.2.2404+dfsg1-4";
      patch = "fix-national-encoding.patch";
      hash = "sha256-oo29H/SN+c/yojtEkFUG99Gc+hJd5sNxZfxV5TzPtRY=";
    })
    (fetchDebianPatch {
      inherit (finalAttrs) pname;
      version = "6.2.2404+dfsg1-4";
      patch = "fix_nggui_tcl.patch";
      hash = "sha256-ODDT67+RWBzPhhq/equWsu78x9L/Yrs3U8VQ1Uu0zZw=";
    })
    (fetchDebianPatch {
      inherit (finalAttrs) pname;
      version = "6.2.2404+dfsg1-4";
      patch = "ffmpeg_link_libraries.patch";
      hash = "sha256-S02OPH9hbJjOnBm6JMh6uM5XptcubV24vdyEF0FusoM=";
    })
    (fetchDebianPatch {
      inherit (finalAttrs) pname;
      version = "6.2.2404+dfsg1-4";
      patch = "size_t_int32.patch";
      hash = "sha256-uudf3b97J2TNq4lAzPK1bRrcQv+Z1oVxFE3tKlydJfE=";
    })
    (fetchDebianPatch {
      inherit (finalAttrs) pname;
      version = "6.2.2404+dfsg1-4";
      patch = "link_atomic.patch";
      hash = "sha256-Yf0GNP4BAahWxOO0zIMVvXiROVP0hRM54Fok7jGABlY=";
    })
    (fetchDebianPatch {
      inherit (finalAttrs) pname;
      version = "6.2.2404+dfsg1-4";
      patch = "include_stdlib.patch";
      hash = "sha256-W+NgGBuy/UmzVbPTSqR8FRUlyN/9dl9l9e9rxKklmIc=";
    })
    (fetchDebianPatch {
      inherit (finalAttrs) pname;
      version = "6.2.2404+dfsg1-4";
      patch = "ngappinit_no_MPI.patch";
      hash = "sha256-0PSe5YB0C/goYFvnl9Z+pwM12D4s1qaTRV12/NA7c94=";
    })
  ];

  postPatch = ''
    echo "v${finalAttrs.version}-0" > version.txt
    # create dummy catch2 target and use system catch2
    echo "add_custom_target(project_catch)" > cmake/external_projects/catch.cmake
  '';

  nativeBuildInputs = [
    # dummy dependency to pass the cmake requirement
    # get version via version.txt rather than git describe
    git
    cmake
    makeWrapper
    python3.pkgs.pybind11-stubgen
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

  propagatedBuildInputs = with python3.pkgs; [
    packaging
    pybind11
    mpi4py
    numpy
  ];

  archFlags = toString (
    lib.optional avxSupport "-mavx"
    ++ lib.optional avx2Support "-mavx2"
    ++ lib.optional avx512Support "-mavx512"
  );

  preConfigure = ''
    cmakeFlagsArray+=(-DCMAKE_CXX_FLAGS="$archFlags")
  '';

  cmakeFlags = [
    (lib.cmakeBool "BUILD_SHARED_LIBS" (!stdenv.hostPlatform.isStatic))
    (lib.cmakeBool "USE_MPI" true)
    (lib.cmakeBool "USE_MPI4PY" true)
    (lib.cmakeBool "PREFER_SYSTEM_PYBIND11" true)
    (lib.cmakeBool "BUILD_STUB_FILES" false)
    (lib.cmakeBool "USE_SUPERBUILD" false)
    (lib.cmakeBool "USE_NATIVE_ARCH" false)
    (lib.cmakeBool "USE_JPEG" true)
    (lib.cmakeBool "USE_MPEG" true)
    (lib.cmakeBool "BUILD_TESTING" finalAttrs.finalPackage.doInstallCheck)
    (lib.cmakeBool "ENABLE_UNIT_TESTS" finalAttrs.finalPackage.doInstallCheck)
  ];

  postInstall = ''
    export PYTHONPATH=$out/${python3.sitePackages}:$PYTHONPATH
    pybind11-stubgen netgen -o $out/${python3.sitePackages}
    wrapProgram "$out/bin/netgen" \
      --set LD_LIBRARY_PATH "$out/lib"\
      --set NETGENDIR "$out/share"
  '';

  doInstallCheck = true;

  installCheckTarget = "test";

  # Mesh generation differs on x86_64 and aarch64 platform.
  # Replace results.json on aarch64 platform with the preset one generated on
  # aarch64 host by `python tests/pytest/test_tutorials.py results-aarch64.json`.
  preInstallCheck = lib.optionalString stdenv.hostPlatform.isAarch64 ''
    cp -f ${./results-aarch64.json} ../tests/pytest/results.json
  '';

  nativeInstallCheckInputs = [
    catch2
    python3.pkgs.pytest
    python3.pkgs.pytest-check
    python3.pkgs.pytest-mpi
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
