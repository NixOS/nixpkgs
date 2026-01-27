{
  lib,
  config,
  pkgs,
  ...
}:
lib.contracts.filebackup.behaviorTest {
  name = "contracts-filebackup-restic";
  providerRoot = [
    "services"
    "restic"
    "fileBackups"
    "mybackup"
  ];
  extraModules = [
    ../../../modules/services/backup/restic.nix
    (
      { config, ... }:
      {
        systemd.tmpfiles.rules = [
          "d '${config.test.repository}' 0750 ${config.test.username} root - -"
        ];

        services.restic.fileBackups.mybackup = {
          providerOptions = {
            inherit (config.test) repository;
            passwordFile = toString (pkgs.writeText "password" "password");
            initialize = true;
          };
        };
      }
    )
  ];
}
// {
  meta.maintainers = [ lib.maintainers.ibizaman ];
}
