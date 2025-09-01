{ lib, callPackage, ... }@args:

let
  common = opts: callPackage (import ./builder.nix lib opts);
  extraArgs = builtins.removeAttrs args [ "callPackage" ];
in
rec {
  rke2_1_30 = common (
    (import ./1_30/versions.nix)
    // {
      updateScript = [
        ./update-script.sh
        "30"
      ];
    }
  ) extraArgs;

  rke2_1_31 = common (
    (import ./1_31/versions.nix)
    // {
      updateScript = [
        ./update-script.sh
        "31"
      ];
    }
  ) extraArgs;

  rke2_1_32 = common (
    (import ./1_32/versions.nix)
    // {
      updateScript = [
        ./update-script.sh
        "32"
      ];
    }
  ) extraArgs;

  # Automatically set by update script
  rke2_stable = rke2_1_31;
  rke2_latest = rke2_1_32;
}
