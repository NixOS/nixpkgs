{ lib, callPackage, ... }@args:

let
  common = opts: callPackage (import ./builder.nix lib opts);
  extraArgs = builtins.removeAttrs args [ "callPackage" ];
in
rec {
  rke2_1_29 = common (
    (import ./1_29/versions.nix)
    // {
      updateScript = [
        ./update-script.sh
        "29"
      ];
    }
  ) extraArgs;

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

  rke2_latest = common (
    (import ./latest/versions.nix)
    // {
      updateScript = [
        ./update-script.sh
        "latest"
      ];
    }
  ) extraArgs;

  rke2_stable = rke2_1_31;
}
