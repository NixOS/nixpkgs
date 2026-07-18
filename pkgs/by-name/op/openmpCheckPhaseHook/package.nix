{
  lib,
  makeSetupHook,
}:

makeSetupHook {
  name = "omp-checkPhase-hook";

  __structuredAttrs = true;

  meta.license = lib.licenses.mit;
} ./omp-check-hook.sh
