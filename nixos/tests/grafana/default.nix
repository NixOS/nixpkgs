{
  runTest,
}:

{
  basic = runTest ./basic.nix;
  provision = runTest ./provision;
}
