{ makeSetupHook, strip-nondeterminism }:

makeSetupHook {
  name = "strip-java-archives-hook";
  propagatedBuildInputs = [ strip-nondeterminism ];
} ./strip-java-archives.sh
