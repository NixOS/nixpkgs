{ lib, callPackage, ... }@args:

let
  common = opts: callPackage (import ./builder.nix lib opts);
  extraArgs = builtins.removeAttrs args [ "callPackage" ];
in
{
  rke2_1_29 = common (
    (import ./1_29/versions.nix)
    // {
      updateScript = [
        ./update-script.sh
        "29"
      ];
    }
  ) extraArgs;

  rke2_stable = common (
    (import ./stable/versions.nix)
    // {
      updateScript = [
        ./update-script.sh
        "stable"
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
}
