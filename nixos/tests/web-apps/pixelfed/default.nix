{ system ? builtins.currentSystem, handleTestOn }:
let
  supportedSystems = [ "x86_64-linux" "i686-linux" ];

in
{
  standard = handleTestOn supportedSystems ./standard.nix { inherit system; };
}
