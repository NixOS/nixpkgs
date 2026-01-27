{
  lib,
  config,
  pkgs,
  ...
}:
lib.contracts.secrets.behaviorTest {
  name = "contracts-secrets-hardcoded-secret";
  providerRoot = [
    "testing"
    "hardcoded-secret"
    "mysecret"
  ];
  extraModules = [
    ../../../modules/testing/hardcoded-secret.nix
    (
      { config, ... }:
      {
        testing.hardcoded-secret.mysecret.providerOptions.content = config.test.content;
      }
    )
  ];
}
// {
  meta.maintainers = [ lib.maintainers.ibizaman ];
}
