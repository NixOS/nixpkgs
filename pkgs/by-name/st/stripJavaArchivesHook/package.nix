{
  lib,
  makeSetupHook,
  strip-nondeterminism,
}:

makeSetupHook {
  name = "strip-java-archives-hook";
  propagatedBuildInputs = [ strip-nondeterminism ];
  meta.license = lib.licenses.mit;
} ./strip-java-archives.sh
