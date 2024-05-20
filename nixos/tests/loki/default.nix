{ runTest }:

{
  standalone = runTest ./standalone.nix;
  ssd = runTest ./ssd.nix;
}
