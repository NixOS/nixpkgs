args@{ lib, pkgs, ... }:
let
  genericTest = import ./genericTest.nix args;
in
genericTest {
  providerName = "restic";
  maintainers = [ lib.maintainers.ibizaman ];

  providerRoot = [
    "services"
    "restic"
    "backups"
    "mytest"
    "fileBackupContract"
  ];

  imports = [
    ../../../modules/services/backup/restic.nix
    (
      { config, ... }:
      {
        systemd.tmpfiles.rules = [
          "d /opt/repos/mytest 0750 ${config.test.input.user} root - -"
        ];

        services.restic.backups.mytest = {
          initialize = true;
          passwordFile = "${pkgs.writeText "passphrase" "mypassphrase"}";
          repository = "/opt/repos/mytest";
        };
      }
    )
  ];
}
