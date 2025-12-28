{
  runTest,
}:
{
  basic = runTest (import ./basic.nix);
  with-container = runTest (import ./with-container.nix);
}
