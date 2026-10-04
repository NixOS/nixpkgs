args@{ lib, pkgs, ... }:
let
  genericTest = import ./genericTest.nix args;
in
genericTest {
  providerName = "borgbackup";
  maintainers = [ lib.maintainers.ibizaman ];

  providerRoot = [
    "services"
    "borgbackup"
    "jobs"
    "mytest"
    "fileBackupContract"
  ];

  imports = [
    ../../../modules/services/backup/borgbackup.nix
    (
      { config, ... }:
      {
        services.borgbackup.jobs.mytest = {
          doInit = true;
          encryption.mode = "repokey";
          encryption.passphrase = "${pkgs.writeText "passphrase" "mypassphrase"}";
          repo = "/opt/repos/mytest";
        };
      }
    )
  ];
}
