f: {
  system ? builtins.currentSystem,
  pkgs ? import ../.. { inherit system; },
  hydra ? false,
  ...
} @ args:

with import ../lib/testing-python.nix { inherit system pkgs hydra; };

makeTest (if pkgs.lib.isFunction f then f (args // { inherit pkgs; inherit (pkgs) lib; }) else f)
