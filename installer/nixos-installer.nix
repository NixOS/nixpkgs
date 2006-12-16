{ stdenv, runCommand, substituteAll, nix
, # URL of the Nixpkgs distribution that the installer will pull.
  # Leave empty for a pure source distribution.
  nixpkgsURL ? ""
}:

substituteAll {
  src = ./nixos-installer.sh;
  dir = "bin";
  isExecutable = true;
  inherit nix nixpkgsURL;

  pathsFromGraph = ../helpers/paths-from-graph.sh;

  nixClosure = runCommand "closure"
    {exportReferencesGraph = ["refs" nix];}
    "cp refs $out";
}
