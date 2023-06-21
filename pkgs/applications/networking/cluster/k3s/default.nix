{ lib, stdenv, callPackage }:

let
  k3s_builder = import ./builder.nix lib;
  common = opts: callPackage (k3s_builder opts);
in
{
  k3s_1_26 = common ((import ./1_26/versions.nix) // {
    updateScript = [ ./update-script.sh "26" ];
  }) { };
}
