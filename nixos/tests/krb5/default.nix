{ system ? builtins.currentSystem }:
{
  example-config = import ./example-config.nix { inherit system; };
}
