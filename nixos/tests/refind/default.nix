{
  runTest,
  ...
}:
{
  basic = runTest ./basic.nix;
  specialisations = runTest ./specialisations.nix;
  efi-no-touch-vars = runTest ./efi-no-touch-vars.nix;
}
