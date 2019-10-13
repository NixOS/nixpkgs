{ backdoorShell ? null }:
f: {
  system ? builtins.currentSystem,
  pkgs ? import ../.. { inherit system; config = {}; },
  ...
} @ args:

  with import ../lib/testing.nix { inherit system pkgs backdoorShell; };

  makeTest (if pkgs.lib.isFunction f then f (args // { inherit pkgs; inherit (pkgs) lib; }) else f)

