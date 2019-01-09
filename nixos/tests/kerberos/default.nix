{ system ? builtins.currentSystem }:
{
  mit = import ./mit.nix { inherit system; };
  heimdal = import ./heimdal.nix { inherit system; };
}
