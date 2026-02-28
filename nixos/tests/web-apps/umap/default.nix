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
  remote-database = runTestOn supportedSystems ./remote-database.nix;
  port-based = runTestOn supportedSystems ./port-based.nix;
  custom-statics = runTestOn supportedSystems ./custom-statics.nix;
}
