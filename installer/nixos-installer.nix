{stdenv, substituteAll, nix}:

substituteAll {
  src = ./nixos-installer.sh;
  dir = "bin";
  isExecutable = true;
  inherit nix;

  pathsFromGraph = ../helpers/paths-from-graph.sh;

  nixClosure = stdenv.mkDerivation {
    name = "closure";
    exportReferencesGraph = ["refs" nix];
    builder = builtins.toFile "builder.sh" "source $stdenv/setup; cp refs $out";
  };
}
