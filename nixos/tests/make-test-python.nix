f: {
  system ? builtins.currentSystem,
  pkgs ? import ../.. { inherit system; },
  hostPkgs ? pkgs,
  ...
} @ args:

with import ../lib/testing-python.nix { inherit system pkgs hostPkgs; };

let testConfig = makeTest (if pkgs.lib.isFunction f then f (args // { inherit pkgs; inherit (pkgs) lib; }) else f);
in testConfig.test   # For nix-build
     // testConfig   # For all-tests.nix
