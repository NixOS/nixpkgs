{
  lib,
  config,
  pkgs,
  ...
}:
let
  inherit
    ((import ../../../modules/contracts/fileBackup.nix {
      inherit lib;
    }).contracts.fileBackup
    )
    behaviorTest
    ;
in
{
  name = "contracts-fileBackup-restic";
  meta.maintainers = [ lib.maintainers.ibizaman ];
  # I tried using the following line but it leads to infinite recursion.
  # Instead, I made a hacky import. pkgs.callPackage was also giving an
  # infinite recursion.
  #
  #     } // config.contracts.fileBackup.behaviorTest {
  #
  # Maybe the answer is in how [[file:~/Projects/nixpkgs/pkgs/development/cuda-modules/modules/generic/types/default.nix::config.generic.types = {][this]] works.
}
// behaviorTest {
  providerRoot = [
    "services"
    "restic"
    "backups"
    "mybackup"
    "fileBackup"
  ];
  extraModules = [
    (
      { config, ... }:
      {
        systemd.tmpfiles.rules = [
          "d '${config.test.repository}' 0750 ${config.test.username} root - -"
        ];

        services.restic.backups.mybackup = {
          inherit (config.test) repository;
          passwordFile = toString (pkgs.writeText "password" "password");
          initialize = true;
        };
      }
    )
  ];
}
