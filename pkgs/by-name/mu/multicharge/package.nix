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

assert !blas.isILP64 && !lapack.isILP64;
assert (
  builtins.elem buildType [
    "meson"
    "cmake"
  ]
);

stdenv.mkDerivation rec {
  pname = "multicharge";
  version = "0.3.1";

  src = fetchFromGitHub {
    owner = "grimme-lab";
    repo = "multicharge";
    rev = "v${version}";
    hash = "sha256-8qwM3dpvFoL2WrMWNf14zYtRap0ijdfZ95XaTlkHhqQ=";
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
  ++ lib.optional (buildType == "cmake") cmake;

  buildInputs = [
    blas
    lapack
  ];

  propagatedBuildInputs = [
    mctc-lib
    mstore
  ];

  outputs = [
    "out"
    "dev"
  ];

  doCheck = true;

  postPatch = ''
    patchShebangs --build config/install-mod.py
  '';

  preCheck = ''
    export OMP_NUM_THREADS=2
  '';

  meta = with lib; {
    description = "Electronegativity equilibration model for atomic partial charges";
    mainProgram = "multicharge";
    license = licenses.asl20;
    homepage = "https://github.com/grimme-lab/multicharge";
    platforms = platforms.linux;
    maintainers = [ maintainers.sheepforce ];
  };
}
