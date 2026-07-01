{
  lib,
  ...
}:
{
  meta.maintainers = [ lib.maintainers.ibizaman ];
}
// lib.contracts.fileSecrets.behaviorTest {
  name = "hardcoded-secret";
  wantPath = [ "mysecret" ];
  extraModules = [
    ../../../modules/testing/hardcoded-secret.nix
    (
      { config, ... }:
      {
        contracts.fileSecrets.defaultProvider = config.contracts.fileSecrets.providers.hardcoded-secret;
        testing.hardcoded-secret.fileSecrets."mysecret".content = config.test.content;
      }
    )
  ];
}
