{ lib, callPackage, ... }@args:

let
  k3s_builder = import ./builder.nix lib;
  common = opts: callPackage (k3s_builder opts);
  # extraArgs is the extra arguments passed in by the caller to propagate downward.
  # This is to allow all-packages.nix to do:
  #
  #     let k3s_1_23 = (callPackage ./path/to/k3s {
  #       commonK3sArg = ....
  #     }).k3s_1_23;
  extraArgs = removeAttrs args [ "callPackage" ];
in
{
  k3s_1_31 = common (
    (import ./1_31/versions.nix)
    // {
      updateScript = [
        ./update-script.sh
        "31"
      ];
    }
  ) extraArgs;

  k3s_1_32 = common (
    (import ./1_32/versions.nix)
    // {
      updateScript = [
        ./update-script.sh
        "32"
      ];
    }
  ) extraArgs;

  k3s_1_33 = common (
    (import ./1_33/versions.nix)
    // {
      updateScript = [
        ./update-script.sh
        "33"
      ];
    }
  ) extraArgs;

  k3s_1_34 =
    (common (
      (import ./1_34/versions.nix)
      // {
        updateScript = [
          ./update-script.sh
          "34"
        ];
      }
    ) extraArgs).overrideAttrs
      {
        patches = [
          # Sets -mod=readonly for go list commands in scripts/version.sh to prevent go from using
          # the (intentional) incomplete vendor directory. Additionally, sets -e for go list to
          # change handling of erroneous packages.
          ./1_34/version_sh_go_list.patch
          # Adds explicit require of opencontainers/runc to go.mod before version.sh is called and
          # removes it afterwards so that later build commands don't complain about inconsistent
          # vendoring.
          ./1_34/go_runc_require.patch
        ];
      };
}
