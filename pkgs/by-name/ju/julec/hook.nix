{
  lib,
  julec,
  makeSetupHook,
}:

makeSetupHook {
  name = "julec-hook";

  propagatedBuildInputs = [ julec ];

  meta = {
    inherit (julec.meta) maintainers;
    license = lib.licenses.mit;
  };
} ./hook.sh
