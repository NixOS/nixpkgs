# `userborn` creates the users after activation.
# Thus the provider must set the owner of the secret after `userborn` runs.
{ lib, ... }:
{
  imports = [ ./hardcoded-secret.nix ];
  name = lib.mkForce "contracts_filesecrets_contracts-secrets-hardcoded-secret-userborn";
  nodes.machine.services.userborn.enable = true;
}
