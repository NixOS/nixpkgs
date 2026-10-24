args@{
  lib,
  config,
  pkgs,
  ...
}:
let
  test = import ./test.nix args;
in
test {
  name = "contracts-secrets-hardcoded-secret";
  providerRoot = [
    "testing"
    "hardcoded-secret"
    "fileSecrets"
    "mysecret"
  ];
  extraModules = [
    ../../../modules/testing/hardcoded-secret.nix
    (
      { config, ... }:
      {
        # A user and group that the configuration creates, so that the test
        # fails when the provider sets the owner before the user exists.
        test.owner = "secretowner";
        test.group = "secretgroup";
        testing.hardcoded-secret.fileSecrets.mysecret.providerOptions.content = config.test.content;
      }
    )
  ];
}
// {
  meta.maintainers = with lib.maintainers; [
    ibizaman
    kiara
  ];
}
