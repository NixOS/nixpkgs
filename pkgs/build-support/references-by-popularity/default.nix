{
  runCommand,
  python3,
  coreutils,
}:
# Write the references of `path' to a file, in order of how "popular" each
# reference is. Nix 2 only.
path:
runCommand "closure-paths"
  {
    exportReferencesGraph.graph = path;
    __structuredAttrs = true;

    nativeBuildInputs = [
      coreutils
      python3
    ];
  }
  ''
    python3 ${./closure-graph.py} "$NIX_ATTRS_JSON_FILE" graph > ''${outputs[out]}
  ''
