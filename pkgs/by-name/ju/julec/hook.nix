{
  julec,
  makeSetupHook,
}:

makeSetupHook {
  name = "julec-hook";

  propagatedBuildInputs = [ julec ];

  meta = {
    inherit (julec.meta) maintainers;
  };
} ./hook.sh
