{
  config,
  lib,

  fetchFromGitHub,
  stdenv,

  nix-update-script,

  enableCuda ? config.cudaSupport,

  # nativeBuildInputs
  cudaPackages,
  gfortran,
  meson,
  ninja,
  pkg-config,

  # buildInputs
  blas,
  hwloc,
  lapack,
  llvmPackages,
  metis,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "spral";
  version = "2025.09.18";

  src = fetchFromGitHub {
    owner = "ralna";
    repo = "spral";
    tag = "v${finalAttrs.version}";
    hash = "sha256-ftyA6zP+VX0fb7e9YKjPCAWYblNyjX/eVeni1tRQIxY=";
  };

  # Ignore a failing test on darwin
  # ref. https://github.com/ralna/spral/issues/258
  postPatch = lib.optionalString stdenv.hostPlatform.isDarwin ''
    substituteInPlace tests/ssids/meson.build --replace-fail \
      "spral_tests += [['ssids', 'ssidst', files('ssids.f90')]]" ""
  '';

  nativeBuildInputs = [
    gfortran
    meson
    ninja
    pkg-config
  ]
  ++ lib.optionals enableCuda [
    cudaPackages.cuda_nvcc
  ];

  propagatedBuildInputs = lib.optionals enableCuda [
    cudaPackages.cuda_cudart
    cudaPackages.libcublas
  ];

  buildInputs = [
    blas
    (hwloc.override { inherit enableCuda; })
    lapack
    metis
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [ llvmPackages.openmp ];

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
