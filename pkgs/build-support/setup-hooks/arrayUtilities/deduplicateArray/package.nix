{
  callPackages,
  isDeclaredArray,
  isDeclaredMap,
  lib,
  makeSetupHook',
}:
makeSetupHook' {
  name = "deduplicateArray";
  script = ./deduplicateArray.bash;
  nativeBuildInputs = [
    isDeclaredArray
    isDeclaredMap
  ];
  passthru.tests = callPackages ./tests.nix { };
  meta = {
    description = "Removes duplicate elements from an array";
    maintainers = [ lib.maintainers.connorbaker ];
  };
}
