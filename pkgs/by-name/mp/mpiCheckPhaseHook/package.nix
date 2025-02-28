{ callPackage, makeSetupHook }:

makeSetupHook {
  name = "mpi-checkPhase-hook";

  substitutions = {
    topology = ./topology.xml;
  };
} ./mpi-check-hook.sh
