let
  requiredVersion = import ./lib/minver.nix;
  forcedAntiquotations = builtins ? forceSmartAntiquotations && builtins.forceSmartAntiquotations;

in

if ! builtins ? nixVersion || builtins.compareVersions requiredVersion builtins.nixVersion == 1 then

  abort "This version of Nixpkgs requires Nix >= ${requiredVersion}, please upgrade! See https://nixos.org/wiki/How_to_update_when_Nix_is_too_old_to_evaluate_Nixpkgs"

else

  builtins.deepSeq forcedAntiquotations (import ./pkgs/top-level)
