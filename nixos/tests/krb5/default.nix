{ system ? builtins.currentSystem }:
{
  example-config = import ./example-config.nix { inherit system; };
  deprecated-config = import ./deprecated-config.nix { inherit system; };
}
