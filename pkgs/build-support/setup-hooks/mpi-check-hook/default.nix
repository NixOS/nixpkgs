{ callPackage, makeSetupHook }:

makeSetupHook {
  name = "mpi-checkPhase-hook";
} ./mpi-check-hook.sh
