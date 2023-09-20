{ runCommand, python3, coreutils }:
# Write the references of `path' to a file, in order of how "popular" each
# reference is. Nix 2 only.
path: runCommand "closure-paths"
{
  exportReferencesGraph.graph = path;
  __structuredAttrs = true;
  preferLocalBuild = true;
  PATH = "${coreutils}/bin:${python3}/bin";
  builder = builtins.toFile "builder"
    ''
      . .attrs.sh
      python3 ${./closure-graph.py} .attrs.json graph > ''${outputs[out]}
    '';
  }
  ""
