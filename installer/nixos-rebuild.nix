{substituteAll, nix}:

substituteAll {
  name = "nixos-rebuild";
  src = ./nixos-rebuild.sh;
  dir = "bin";
  isExecutable = true;
  inherit nix;
}
