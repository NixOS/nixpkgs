{
  lib,
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

  meta.license = lib.licenses.mit;
} ./mpi-check-hook.sh
