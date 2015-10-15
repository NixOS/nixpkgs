let
  minVersion = "1.10";
in
  with builtins;
  if ! builtins ? nixVersion || compareVersions minVersion nixVersion == 1 then

    abort ("This version of Nixpkgs requires Nix >= ${minVersion}, please upgrade!"
      + " See https://nixos.org/wiki/How_to_update_when_nix_is_too_old_to_evaluate_nixpkgs")

  else

    import ./pkgs/top-level/all-packages.nix
