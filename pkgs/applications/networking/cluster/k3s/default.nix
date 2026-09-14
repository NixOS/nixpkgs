{ lib, callPackage, ... }@args:

let
  k3s_builder = import ./builder.nix lib;
  forVersions = versions: callPackage (k3s_builder (import versions)) extraArgs;
  # extraArgs is the extra arguments passed in by the caller to propagate downward.
  # This is to allow all-packages.nix to do:
  #
  #     let k3s_1_23 = (callPackage ./path/to/k3s {
  #       commonK3sArg = ....
  #     }).k3s_1_23;
  extraArgs = removeAttrs args [ "callPackage" ];
in
{
  k3s_1_34 = forVersions ./1_34/versions.nix;
  k3s_1_35 = forVersions ./1_35/versions.nix;
  k3s_1_36 = forVersions ./1_36/versions.nix;
}
