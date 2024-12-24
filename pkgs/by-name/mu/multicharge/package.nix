{
  stdenv,
  lib,
  fetchFromGitHub,
  gfortran,
  meson,
  ninja,
  pkg-config,
  python3,
  blas,
  lapack,
  mctc-lib,
  mstore,
}:

assert !blas.isILP64 && !lapack.isILP64;

stdenv.mkDerivation rec {
  pname = "multicharge";
  version = "0.3.0";

  src = fetchFromGitHub {
    owner = "grimme-lab";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-W6IqCz9k6kdPxnIIA+eMCrFjf0ELTeK78VvZoyFcZxU=";
  };

  nativeBuildInputs = [
    gfortran
    meson
    ninja
    pkg-config
    python3
  ];

  buildInputs = [
    blas
    lapack
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
