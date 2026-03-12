{ runTest }:

{
  client = runTest ./client.nix;
  server-signal = runTest ./server-signal.nix;
  server-management = runTest ./server-management.nix;
  server-relay = runTest ./server-relay.nix;
}
