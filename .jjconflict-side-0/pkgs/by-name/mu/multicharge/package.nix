{
  stdenv,
  lib,
  fetchFromGitHub,
  gfortran,
  buildType ? "meson",
  meson,
  ninja,
  cmake,
  pkg-config,
  python3,
  blas,
  lapack,
  mctc-lib,
  mstore,
}:

assert blas.isILP64 == lapack.isILP64;
assert (
  builtins.elem buildType [
    "meson"
    "cmake"
  ]
);

stdenv.mkDerivation (finalAttrs: {
  pname = "multicharge";
  version = "0.5.0";
  __structuredAttrs = true;
  strictDeps = true;

  src = fetchFromGitHub {
    owner = "grimme-lab";
    repo = "multicharge";
    tag = "v${finalAttrs.version}";
    hash = "sha256-hswqC+fvC6tuxDpuUgowyqm72ubVikzpR4EzXtTM5cs=";
  };

  patches = [
    # Fix wrong generation of package config include paths
    ./pkgconfig.patch
  ];

  nativeBuildInputs = [
    gfortran
    pkg-config
    python3
  ]
  ++ lib.optionals (buildType == "meson") [
    meson
    ninja
  ]
  ++ lib.optionals (buildType == "cmake") [
    cmake
  ];

  buildInputs = [
    blas
    lapack
  ];

  propagatedBuildInputs = [
    mctc-lib
    mstore
  ];

  # For the Meson build, the `ilp64` option sets the -DIK=i8 preprocessor flag
  # for 64-bit integer BLAS/LAPACK calls.  Because nixpkgs always provides the
  # BLAS library as `libblas` (regardless of the integer size), the `custom`
  # LAPACK vendor is used with explicit library names when ILP64 is enabled,
  # instead of the upstream default which would look for `libblas64`.
  mesonFlags = [
    "-Dilp64=${if blas.isILP64 then "true" else "false"}"
  ]
  ++ lib.optionals blas.isILP64 [
    "-Dlapack=custom"
    "-Dcustom_libraries=blas,lapack"
  ];

  cmakeFlags = [
    (lib.cmakeBool "WITH_ILP64" blas.isILP64)
  ]
  ++ lib.optionals blas.isILP64 [
    "-DBLAS_LIBRARIES=${lib.getLib blas}/lib/libblas${
      if stdenv.hostPlatform.isStatic then ".a" else stdenv.hostPlatform.extensions.sharedLibrary
    }"
    "-DLAPACK_LIBRARIES=${lib.getLib lapack}/lib/liblapack${
      if stdenv.hostPlatform.isStatic then ".a" else stdenv.hostPlatform.extensions.sharedLibrary
    }"
  ];

  outputs = [
    "out"
    "dev"
  ];

  doCheck = true;

  postPatch = ''
    patchShebangs --build config/install-mod.py

    # custom blas and lapack need to be explicitly found for transitive dependencies
    # otherwise CMAKE builds can not proceed.
    echo 'set(custom-blas_FOUND TRUE)' >> config/cmake/Findcustom-blas.cmake
    echo 'set(custom-lapack_FOUND TRUE)' >> config/cmake/Findcustom-lapack.cmake
  '';

  meta = {
    description = "Electronegativity equilibration model for atomic partial charges";
    mainProgram = "multicharge";
    license = lib.licenses.asl20;
    homepage = "https://github.com/grimme-lab/multicharge";
    changelog = "https://github.com/grimme-lab/multicharge/releases/tag/${finalAttrs.src.tag}";
    platforms = lib.platforms.linux;
    maintainers = [ lib.maintainers.sheepforce ];
  };
})
