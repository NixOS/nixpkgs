{ stdenv, genericSubstituter, shell, nix
}:

genericSubstituter {
  src = ./installer.sh;
  dir = "bin";
  isExecutable = true;
  inherit shell nix;

  pathsFromGraph = ./paths-from-graph.sh;

  nixClosure = stdenv.mkDerivation {
    name = "closure";
    exportReferencesGraph = ["refs" nix];
    builder = builtins.toFile "builder.sh" "source $stdenv/setup; cp refs $out";
  };
}
