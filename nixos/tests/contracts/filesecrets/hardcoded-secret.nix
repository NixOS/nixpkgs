{
  lib,
  ...
}:
{
  meta.maintainers = [ lib.maintainers.ibizaman ];
}
// lib.contracts.fileSecrets.behaviorTest {
  name = "hardcoded-secret";
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
        contracts.fileSecrets.defaultProviderName = "hardcoded-secret";
        testing.hardcoded-secret.fileSecrets."mysecret".content = config.test.content;
      }
    )
  ];
}
