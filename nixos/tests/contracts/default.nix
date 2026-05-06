{ runTest }:
{
  chaining = runTest ./chaining.nix;
  cross-node = runTest ./cross-node.nix;
  database-modular-services = runTest ./database-modular-services.nix;
  filesecrets-hardcoded-secret = runTest ./filesecrets/hardcoded-secret.nix;
  collision = runTest ./collision-test.nix;
  modular-services = runTest ./modular-services.nix;
  nested-services = runTest ./nested-services.nix;
  nixos-provider-modular-consumer = runTest ./nixos-provider-modular-consumer.nix;
}
