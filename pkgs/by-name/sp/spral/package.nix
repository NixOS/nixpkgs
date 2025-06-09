{
  blas,
  fetchFromGitHub,
  gfortran,
  lapack,
  lib,
  llvmPackages,
  meson,
  metis,
  ninja,
  stdenv,
}:

stdenv.mkDerivation rec {
  pname = "spral";
  version = "2025.05.20";

  src = fetchFromGitHub {
    owner = "ralna";
    repo = "spral";
    rev = "v${version}";
    hash = "sha256-9QEcAOFB3CtGNqr8LoDaj2vP3KMONlUVooeXECtGsxc=";
  };

  nativeBuildInputs = [
    gfortran
    meson
    ninja
  ];

  buildInputs = [
    blas
    lapack
    metis
  ] ++ lib.optionals stdenv.hostPlatform.isDarwin [ llvmPackages.openmp ];

  mesonFlags = [ (lib.mesonBool "tests" true) ];

  LDFLAGS = lib.optionals stdenv.hostPlatform.isDarwin [ "-lomp" ];

  doCheck = true;

  meta = {
    description = "Sparse Parallel Robust Algorithms Library";
    homepage = "https://github.com/ralna/spral";
    changelog = "https://github.com/ralna/spral/blob/${src.rev}/ChangeLog";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ nim65s ];
  };
}
