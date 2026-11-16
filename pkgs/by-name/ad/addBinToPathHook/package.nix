{
  lib,
  makeSetupHook,
}:

makeSetupHook {
  name = "add-bin-to-path-hook";
  meta.license = lib.licenses.mit;
} ./add-bin-to-path.sh
