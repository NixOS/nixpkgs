let requiredVersion = import ./lib/minver.nix; in

if ! builtins ? nixVersion || builtins.compareVersions requiredVersion builtins.nixVersion == 1 then

  abort "This version of Nixpkgs requires Nix >= ${requiredVersion}, please upgrade! See https://nixos.org/nixpkgs/manual/#upgrading-nix"

else

  import ./pkgs/top-level/impure.nix
