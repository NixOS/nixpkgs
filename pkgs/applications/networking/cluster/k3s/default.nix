{ lib, callPackage, ... }@args:

let
  k3s_builder = import ./builder.nix lib;
  common = opts: callPackage (k3s_builder opts);
  # extraArgs is the extra arguments passed in by the caller to propogate downward.
  # This is to allow all-packages.nix to do:
  #
  #     let k3s_1_23 = (callPackage ./path/to/k3s {
  #       commonK3sArg = ....
  #     }).k3s_1_23;
  extraArgs = builtins.removeAttrs args [ "callPackage" ];
in
{
  k3s_1_26 = common ((import ./1_26/versions.nix) // {
    updateScript = [ ./update-script.sh "26" ];
  }) extraArgs;

  # 1_27 can be built with the same builder as 1_26
  k3s_1_27 = common ((import ./1_27/versions.nix) // {
    updateScript = [ ./update-script.sh "27" ];
  }) extraArgs;

  # 1_28 can be built with the same builder as 1_26
  k3s_1_28 = common ((import ./1_28/versions.nix) // {
    updateScript = [ ./update-script.sh "28" ];
  }) extraArgs;

  # 1_29 can be built with the same builder as 1_26
  k3s_1_29 = common ((import ./1_29/versions.nix) // {
    updateScript = [ ./update-script.sh "29" ];
  }) extraArgs;
}
