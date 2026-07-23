{
  lib,
  makeSetupHook,
}:

makeSetupHook {
  name = "check-phase-thread-limit-hook";

  __structuredAttrs = true;

  meta = {
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ grimmauld ];
  };
} ./hook.sh
