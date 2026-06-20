{
  stdenv,
  lib,
  fetchFromGitHub,
  gfortran,
  buildType ? "meson",
  cmake,
  meson,
  ninja,
  pkg-config,
  python3,
  blas,
  lapack,
  mctc-lib,
  mstore,
  multicharge,
}:

assert !blas.isILP64 && !lapack.isILP64;
assert (
  builtins.elem buildType [
    "meson"
    "cmake"
  ]
);

stdenv.mkDerivation (finalAttrs: {
  pname = "dftd4";
  version = "4.2.0";

  src = fetchFromGitHub {
    owner = "dftd4";
    repo = "dftd4";
    rev = "v${finalAttrs.version}";
    hash = "sha256-uKjNOIza3/I0oREp88oFESoNqEdumo1AztIjcrVb1O8=";
  };

  patches = [
    # Fix pkg-config, meson and cmake paths for include and lib dirs
    ./build-paths.patch
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
  ++ lib.optional (buildType == "cmake") cmake;

  buildInputs = [
    blas
    lapack
  ];

  propagatedBuildInputs = [
    mctc-lib
    mstore
    multicharge
  ];

  cmakeFlags = [
    (lib.strings.cmakeBool "BUILD_SHARED_LIBS" (!stdenv.hostPlatform.isStatic))
  ];

  outputs = [
    "out"
    "dev"
  ];

  doCheck = true;

  postPatch = ''
    patchShebangs --build \
      config/install-mod.py \
      app/tester.py
  '';

  preCheck = ''
    export OMP_NUM_THREADS=2
  '';

  meta = {
    description = "Generally Applicable Atomic-Charge Dependent London Dispersion Correction";
    mainProgram = "dftd4";
    license = with lib.licenses; [
      lgpl3Plus
      gpl3Plus
    ];
    homepage = "https://github.com/grimme-lab/dftd4";
    platforms = lib.platforms.linux;
    maintainers = [ lib.maintainers.sheepforce ];
  };
})
