{stdenv, runCommand, substituteAll, nix}:

substituteAll {
  src = ./nixos-installer.sh;
  dir = "bin";
  isExecutable = true;
  inherit nix;

  pathsFromGraph = ../helpers/paths-from-graph.sh;

  nixClosure = runCommand "closure"
    {exportReferencesGraph = ["refs" nix];}
    "cp refs $out";
}
