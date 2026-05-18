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
        # systemd.tmpfiles.rules = [
        #   "d /opt/repos/mytest 0750 ${config.test.input.user} root - -"
        # ];

        services.borgbackup.jobs.mytest = {
          doInit = true;
          encryption.passphrase = "${pkgs.writeText "passphrase" "mypassphrase"}";
          repo = "/opt/repos/mytest";
        };
      }
    )
  ];
}
