{
  system ? builtins.currentSystem,
  pkgs,
  ...
}:
let
  runTest = path: import path { inherit system pkgs; };
in
{
  standard = runTest ./simple.nix;
  with-implicit-systemd-resolved = runTest ./implicit-resolved.nix;
}
