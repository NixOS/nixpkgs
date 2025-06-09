{
  lib,

  fetchFromGitHub,
  stdenv,

  nix-update-script,

  # nativeBuildInputs
  gfortran,
  meson,
  ninja,

  # buildInputs
  blas,
  lapack,
  llvmPackages,
  metis,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "spral";
  version = "2025.05.20";

  src = fetchFromGitHub {
    owner = "ralna";
    repo = "spral";
    tag = "v${finalAttrs.version}";
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

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Sparse Parallel Robust Algorithms Library";
    homepage = "https://github.com/ralna/spral";
    changelog = "https://github.com/ralna/spral/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ nim65s ];
  };
})
