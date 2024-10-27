{ runCommand, python3, coreutils, writeReferencesGraph }:
# Write the references of `path' to a file, in order of how "popular" each
# reference is. Nix 2 only.
path: runCommand "closure-paths"
{
  preferLocalBuild = true;
  nativeBuildInputs = [ coreutils python3 ];
}
''
  python3 ${./closure-graph.py} "${writeReferencesGraph path}" > $out
''
