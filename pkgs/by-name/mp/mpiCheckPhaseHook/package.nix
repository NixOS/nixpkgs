{
  callPackage,
  makeSetupHook,
  stdenv,
}:

makeSetupHook {
  name = "mpi-checkPhase-hook";

  substitutions = {
    iface = if stdenv.hostPlatform.isDarwin then "lo0" else "lo";
    topology = ./topology.xml;
  };
} ./mpi-check-hook.sh
