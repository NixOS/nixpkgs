{
  makeSetupHook,
  stdenv,
  openmpCheckPhaseHook,
}:

makeSetupHook {
  name = "mpi-checkPhase-hook";

  substitutions = {
    iface = if stdenv.hostPlatform.isDarwin then "lo0" else "lo";
    topology = ./topology.xml;
  };

  propagatedNativeBuildInputs = [
    openmpCheckPhaseHook
  ];
} ./mpi-check-hook.sh
