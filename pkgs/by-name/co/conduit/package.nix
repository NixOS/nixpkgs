{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  openmpi,

  # passthru
  conduit,
  python3Packages,
  nix-update-script,

  mpiSupport ? false,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "conduit";
  version = "0.9.5";

  src = fetchFromGitHub {
    owner = "LLNL";
    repo = "conduit";
    tag = "v${finalAttrs.version}";
    fetchSubmodules = true;
    hash = "sha256-mX7/5C4wd70Kx1rQyo2BcZMwDRqvxo4fBdz3pq7PuvM=";
  };

  nativeBuildInputs = [
    cmake
  ];

  cmakeDir = "../src";

  buildInputs = lib.optionals mpiSupport [
    openmpi
  ];

  cmakeFlags = [
    (lib.cmakeBool "ENABLE_MPI" mpiSupport)
  ];

  installCheckPhase = ''
    runHook preInstallCheck

    make test

    runHook postInstallCheck
  '';
  doInstallCheck = true;

  passthru = {
    tests = {
      withMpi = conduit.override { mpiSupport = true; };
      pythonModule = python3Packages.conduit;
      pythonModuleWithMpi = python3Packages.conduit-mpi;
    };
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Simplified Data Exchange for HPC Simulations";
    homepage = "https://github.com/LLNL/conduit";
    changelog = "https://github.com/LLNL/conduit/blob/v${finalAttrs.version}/CHANGELOG.md";
    license = lib.licenses.bsd3Lbnl;
    maintainers = with lib.maintainers; [ GaetanLepage ];
    platforms = lib.platforms.all;
  };
})
