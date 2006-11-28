{ stdenv, genericSubstituter, shell, nix
}:

genericSubstituter {
  src = ./nixos-installer.sh;
  dir = "bin";
  isExecutable = true;
  inherit shell nix;

  pathsFromGraph = ../helpers/paths-from-graph.sh;

  nixClosure = stdenv.mkDerivation {
    name = "closure";
    exportReferencesGraph = ["refs" nix];
    builder = builtins.toFile "builder.sh" "source $stdenv/setup; cp refs $out";
  };
}
