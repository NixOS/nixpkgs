{
  lib,
  pkgs,
  ...
}:
let
  mkResticConfig = name: input: {
    initialize = true;
    repository = "/opt/restic-repos/${name}";
    passwordFile = "${pkgs.writeText "password" "restic-${name}-password"}";

    # fileBackup contract wiring
    fileBackupContract.input = input;
  };

  mkBorgBackupConfig = name: input: {
    doInit = true;
    repo = "/opt/borgbackup-repos/${name}";
    encryption.mode = "repokey";
    encryption.passphrase = "${pkgs.writeText "password" "borgbackup-${name}-password"}";
    environment.BORG_BASE_DIR = "/opt/borgbackup/${name}";
    readWritePaths = [ "/opt/borgbackup/${name}" ];

    # fileBackup contract wiring
    fileBackupContract.input = input;
  };
in
{
  name = "contract_fileBackup_demo";
  meta.maintainers = [ lib.maintainers.ibizaman ];

  nodes.machine =
    { config, ... }:
    {
      services.nextcloud = {
        enable = true;
        hostName = "nextcloud.example.com";
        database.createLocally = true;
        config = {
          adminpassFile = "${pkgs.writeText "password" "nextcloud-password"}";
          dbtype = "sqlite";
        };
      };

      services.home-assistant = {
        enable = true;
      };

      systemd.tmpfiles.rules =
        let
          homeAssistantUser = config.services.restic.backups."home-assistant".fileBackupContract.input.user;
          nextcloudUser = config.services.restic.backups."nextcloud".fileBackupContract.input.user;
        in
        [
          # # Repo directories for restic
          "d /opt/restic-repos/home-assistant 0750 ${homeAssistantUser} root - -"
          "d /opt/restic-repos/nextcloud 0750 ${nextcloudUser} root - -"

          # Repo directories for borgbackup
          "d /opt/borgbackup-repos/home-assistant 0750 ${homeAssistantUser} root - -"
          "d /opt/borgbackup-repos/nextcloud 0750 ${nextcloudUser} root - -"

          # State directories for borgbackup
          "d /opt/borgbackup/home-assistant 0750 ${homeAssistantUser} root - -"
          "d /opt/borgbackup/nextcloud 0750 ${nextcloudUser} root - -"
        ];

      services.restic.backups."home-assistant" =
        mkResticConfig "home-assistant" config.services.home-assistant.fileBackupContract.input;

      services.borgbackup.jobs."home-assistant" =
        mkBorgBackupConfig "home-assistant" config.services.home-assistant.fileBackupContract.input;

      services.restic.backups."nextcloud" =
        mkResticConfig "nextcloud" config.services.nextcloud.fileBackupContract.input;

      services.borgbackup.jobs."nextcloud" =
        mkBorgBackupConfig "nextcloud" config.services.nextcloud.fileBackupContract.input;

      environment.systemPackages = [
        # fileBackup contract wiring
        config.services.restic.backups."home-assistant".fileBackupContract.output.script
        config.services.borgbackup.jobs."home-assistant".fileBackupContract.output.script
        config.services.restic.backups."nextcloud".fileBackupContract.output.script
        config.services.borgbackup.jobs."nextcloud".fileBackupContract.output.script
      ];
    };

  testScript = ''
    machine.start()

    with subtest("home-assistant"):
        machine.wait_for_unit("home-assistant.service")

        machine.succeed("restic-home-assistant backup")
        print(machine.succeed("restic-home-assistant snapshots"))

        machine.succeed("borgbackup-home-assistant backup")
        print(machine.succeed("borgbackup-home-assistant snapshots"))

    with subtest("nextcloud"):
        machine.wait_for_unit("phpfpm-nextcloud.service")

        machine.succeed("restic-nextcloud backup")
        print(machine.succeed("restic-nextcloud snapshots"))

        machine.succeed("borgbackup-nextcloud backup")
        print(machine.succeed("borgbackup-nextcloud snapshots"))
  '';
}
