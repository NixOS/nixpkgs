f:
{
  system ? builtins.currentSystem,
  pkgs ? import ../.. {
    inherit system;
    config = { };
    overlays = [ ];
  },
  ...
}@args:

with import ../lib/testing-python.nix { inherit system pkgs; };

makeTest (
  if pkgs.lib.isFunction f then
    f (
      args
      // {
        inherit pkgs;
        inherit (pkgs) lib;
      }
    )
  else
    f
)
