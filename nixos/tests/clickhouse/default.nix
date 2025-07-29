{ runTest }:

{
  base = runTest ./base.nix;
  kafka = runTest ./kafka.nix;
  keeper = runTest ./keeper.nix;
  s3 = runTest ./s3.nix;
}
