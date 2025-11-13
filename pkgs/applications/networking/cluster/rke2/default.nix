{ lib, callPackage, ... }@args:

let
  common = opts: callPackage (import ./builder.nix lib opts);
  extraArgs = removeAttrs args [ "callPackage" ];
in
rec {
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

  rke2_1_33 = common (
    (import ./1_33/versions.nix)
    // {
      updateScript = [
        ./update-script.sh
        "33"
      ];
    }
  ) extraArgs;

  rke2_1_34 = common (
    (import ./1_34/versions.nix)
    // {
      updateScript = [
        ./update-script.sh
        "34"
      ];
    }
  ) extraArgs;

  # Automatically set by update script
  rke2_stable = rke2_1_33;
  rke2_latest = rke2_1_34;
}
