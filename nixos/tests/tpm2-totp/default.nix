{ runTest }:
{
  cli = runTest ./cli.nix;
  plymouth = runTest ./plymouth.nix;
}
