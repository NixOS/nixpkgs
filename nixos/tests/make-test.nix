f: { system ? builtins.currentSystem, ... } @ args:

with import ../lib/testing.nix { inherit system; };

makeTest (if lib.isFunction f then f (args // { inherit pkgs; inherit (pkgs) lib; }) else f)
