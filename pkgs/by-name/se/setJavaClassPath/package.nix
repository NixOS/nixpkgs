{
  lib,
  makeSetupHook,
}:

makeSetupHook {
  name = "set-java-classpath-hook";
  meta.license = lib.licenses.mit;
} ./set-java-classpath.sh
