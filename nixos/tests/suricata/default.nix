{ runTest, ... }:
{
  afPacket = runTest ./af-packet.nix;
  nfqueue = runTest ./nfqueue.nix;
}
