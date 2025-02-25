{
  system ? builtins.currentSystem,
  handleTestOn,
}:

let
  supportedSystems = [
    "x86_64-linux"
    "i686-linux"
    "aarch64-linux"
  ];
in
{
  prosody-nginx = handleTestOn supportedSystems ./prosody-nginx.nix { inherit system; };
}
