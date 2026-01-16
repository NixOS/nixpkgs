# Nextcloud backup/restore {#module-services-nextcloudBackup}

A module to backup up and restore a
[nextcloud instance](#module-services-nextcloud).
In order to use the module, add the following snippet
to your NixOS configuration:
```nix
{
  services.nextcloudBackup = {
    enable = true;
    # Replace this by the folder where you want to store the backups
    backupDir = "/var/lib/backups";
  };
}
```

## Backing up the instance {#module-services-nextcloudBackup-backup}

Running the systemd service `nextcloud-backup.service`
creates a backup of the nextcloud instance in a folder
`nextcloud-backup` under `services.nextcloudBackup.backupDir`.
Note that for the duration of the backup, the nextcloud instance
will be put in maintenance mode. Any subsequent runs will only
copy files that changed since the last backup, so they will usually
be much faster.

Since the backup is created on the same machine and neither
versioned nor compressed, it is recommended to combine this
with another backup tool. For example, if a restic backup
is set up via `services.restic.backups.nextcloud`, you can
add the following snippet to your configuration to always run
the nextcloud backup script before:
```nix
{
  systemd.services.restic-backups-nextcloud = {
    requires = [ "nextcloud-backup.service" ];
    after = [ "nextcloud-backup.service" ];
  };
}
```

## Restoring a backup {#module-services-nextcloudBackup-restore}

If you need to restore the nextcloud instance, first ensure
that you have a working nextcloud installation with the correct
version and database type (see the `metadata.json` file in the backup).
Then, run `nextcloud-restore /path/to/backup/` if the backup is contained
in `/path/to/backup/nextcloud-backup`. WARNING: This will delete
all the data of the installed nextcloud instance and replace it
by the data in the backup.


