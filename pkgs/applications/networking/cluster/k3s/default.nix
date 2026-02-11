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
  k3s_1_32 = common (import ./1_32/versions.nix) extraArgs;

  k3s_1_33 = common (import ./1_33/versions.nix) extraArgs;

  k3s_1_34 = (common (import ./1_34/versions.nix) extraArgs).overrideAttrs {
    patches = [ ./go_runc_require.patch ];
  };

  k3s_1_35 = (common (import ./1_35/versions.nix) extraArgs).overrideAttrs {
    patches = [ ./go_runc_require.patch ];
  };
}
