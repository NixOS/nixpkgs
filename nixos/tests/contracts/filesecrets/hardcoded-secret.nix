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
        testing.hardcoded-secret.fileSecrets.mysecret.providerOptions.content = config.test.content;
      }
    )
  ];
}
// {
  meta.maintainers = [ lib.maintainers.ibizaman ];
}
