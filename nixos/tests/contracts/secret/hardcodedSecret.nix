{
  lib,
  config,
  pkgs,
  ...
}:
let
  inherit
    ((import ../../../modules/contracts/secret.nix {
      inherit lib;
    }).contracts.secret
    )
    behaviorTest
    ;
in
{
  name = "contracts-filebackup-restic";
  meta.maintainers = [ lib.maintainers.ibizaman ];
  # I tried using the following line but it leads to infinite recursion.
  # Instead, I made a hacky import. pkgs.callPackage was also giving an
  # infinite recursion.
  #
  #     } // config.contracts.secret.behaviorTest {
  #
}
// behaviorTest {
  providerRoot = [
    "testing"
    "hardcodedSecret"
    "mysecret"
    "secret"
  ];
  extraModules = [
    ../../../modules/testing/hardcodedSecret.nix
    (
      { config, ... }:
      {
        testing.hardcodedSecret.mysecret.content = config.test.content;
      }
    )
  ];
}
