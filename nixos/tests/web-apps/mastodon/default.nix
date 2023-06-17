{ system ? builtins.currentSystem, handleTestOn }:
let
  supportedSystems = [ "x86_64-linux" "i686-linux" "aarch64-linux" ];

in
{
  standard = handleTestOn supportedSystems ./standard.nix { inherit system; };
  remote-postgresql = handleTestOn supportedSystems ./remote-postgresql.nix { inherit system; };
}
