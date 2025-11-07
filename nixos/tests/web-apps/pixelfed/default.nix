{
  runTestOn,
}:
let
  supportedSystems = [
    "x86_64-linux"
    "i686-linux"
  ];
in
{
  standard = runTestOn supportedSystems ./standard.nix;
}
