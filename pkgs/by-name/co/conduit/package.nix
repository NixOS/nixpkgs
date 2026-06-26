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
  version = "0.9.7";

  src = fetchFromGitHub {
    owner = "LLNL";
    repo = "conduit";
    tag = "v${finalAttrs.version}";
    fetchSubmodules = true;
    hash = "sha256-DmnHGj6Q/i+wVNIbaTGrFX9f0Kry2X5bC7zahXv29I4=";
  };

  nativeBuildInputs = [
    cmake
  ];

  cmakeDir = "../src";

  buildInputs = lib.optionals mpiSupport [
    openmpi
  ];

  cmakeFlags = [
    # Don't leak kernel version into the build output for reproducibility
    (lib.cmakeFeature "CMAKE_SYSTEM_VERSION" "")
    (lib.cmakeBool "ENABLE_MPI" mpiSupport)
  ];

  installCheckPhase =
    let
      excludedTests = lib.optionals stdenv.hostPlatform.isDarwin [
        # SIGTRAP***Exception
        "t_conduit_fixed_size_vector"
      ];

      excludedTestsString = lib.optionalString (
        excludedTests != [ ]
      ) "-E '^(${builtins.concatStringsSep "|" excludedTests})$'";
    in
    ''
      runHook preInstallCheck

      ctest --output-on-failure ${excludedTestsString}

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
