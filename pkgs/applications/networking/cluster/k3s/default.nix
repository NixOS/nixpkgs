{ lib, stdenv, callPackage }:

let
  k3s_builder = import ./builder.nix lib;
  common = opts: callPackage (k3s_builder opts);
in
{
  k3s_1_26 = common ((import ./1_26/versions.nix) // {
    updateScript = [ ./update-script.sh "26" ];
  }) { };

  # 1_27 can be built with the same builder as 1_26
  k3s_1_27 = common ((import ./1_27/versions.nix) // {
    updateScript = [ ./update-script.sh "27" ];
  }) { };
}
