{ lib, callPackage, ... }@args:

let
  common = opts: callPackage (import ./builder.nix lib opts);
  extraArgs = builtins.removeAttrs args [ "callPackage" ];
in
{
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

  rke2_testing =
    (common (
      (import ./testing/versions.nix)
      // {
        updateScript = [
          ./update-script.sh
          "testing"
        ];
      }
    ) extraArgs).overrideAttrs
      {
        meta.knownVulnerabilities = [
          "The RKE2 testing channel no longer serves releases, this package will not receive updates."
        ];
      };
}
