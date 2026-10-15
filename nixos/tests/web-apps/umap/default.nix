{
  runTestOn,
}:
let
  supportedSystems = [
    "x86_64-linux"
    "aarch64-linux"
  ];
in
{
  standard = runTestOn supportedSystems ./standard.nix;
  port-based = runTestOn supportedSystems ./port-based.nix;
  secret-key = runTestOn supportedSystems ./secret-key.nix;
  customize = runTestOn supportedSystems ./customize.nix;
}
