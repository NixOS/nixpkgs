# Use exportReferencesGraph to capture the possible dependencies of the
# drivers (e.g. libc linked through DT_RUNPATH) and ensure they are mounted
# in the sandbox as well. In practice, things seemed to have worked without
# this as well, but we go with the safe option until we understand why.

{
  lib,
  runCommand,
  python3Packages,
  allowedPatterns,
}:
runCommand "allowed-patterns.json"
  {
    nativeBuildInputs = [ python3Packages.python ];
    exportReferencesGraph = builtins.concatMap (
      name:
      builtins.concatMap (
        path:
        let
          prefix = "${builtins.storeDir}/";
          # Has to start with a letter: https://github.com/NixOS/nix/blob/516e7ddc41f39ff939b5d5b5dc71e590f24890d4/src/libstore/build/local-derivation-goal.cc#L568
          exportName = ''references-${lib.strings.removePrefix prefix "${path}"}'';
          isStorePath = lib.isStorePath path && (lib.hasPrefix prefix "${path}");
        in
        lib.optionals isStorePath [
          exportName
          path
        ]
      ) allowedPatterns.${name}.paths
    ) (builtins.attrNames allowedPatterns);
    env.storeDir = "${builtins.storeDir}/";
    shallowConfig = builtins.toJSON allowedPatterns;
    passAsFile = [ "shallowConfig" ];
  }
  ''
    python ${./scripts/nix_required_mounts_closure.py}
  ''
