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
  basic = handleTestOn supportedSystems ./basic.nix { inherit system; };
  mruby = handleTestOn supportedSystems ./mruby.nix { inherit system; };
}
