{ runTest }:
{
  local-write = runTest ./local-write.nix;
  remote-write-with-vlagent = runTest ./remote-write-with-vlagent.nix;
}
