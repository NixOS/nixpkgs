if ! builtins ? nixVersion || builtins.compareVersions "1.6" builtins.nixVersion == 1 then

  abort "This version of Nixpkgs requires Nix >= 1.6, please upgrade!"

else

  import ./pkgs/top-level/all-packages.nix
