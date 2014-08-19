f: { system ? builtins.currentSystem, ... } @ args:

with import ../lib/testing.nix { inherit system; };

makeTest (if builtins.isFunction f then f (args // { inherit pkgs; }) else f)
