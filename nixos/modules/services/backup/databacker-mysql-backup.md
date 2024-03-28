# Databacker's MySQL Backup {#module-databacker-mysql-backup}

*Source:* {file}`modules/services/backup/databacker-mysql-backup.nix`

*Upstream documentation:* <https://github.com/databacker/mysql-backup/blob/master/README.md>


[mysql-backup](https://github.com/databacker/mysql-backup) is a simple way to do
MySQL database backups and restores, as well as manage your backups.

It has the following features:

* dump and restore
* dump to local filesystem or to SMB server
* select database user and password
* connect to any container running on the same system
* select how often to run a dump
* select when to start the first dump, whether time of day or relative to container start time
* prune backups older than a specific time period or quantity


The NixOS module allows you to easily configure a systemd service that will
backup your MySQL databases (remotely or locally) and store the dumps on a local
disk, remote samba fs, or AWS S3 compatible service.

If configured with retention settings, the service will automatically prune old backups.

## Configuring {#module-services-backup-databacker-mysql-backup-configuring}

A complete list of options for the MySQL Backup module may be found
[here](#opt-services.databacker-mysql-backup).

## Basic usage for a local backup {#opt-services-backup-databacker-mysql-backup-local-directory}

A very basic configuration for backing up to a locally accessible directory is:

```
{
    services.mysql = {
      enable = true;
      package = pkgs.mariadb;
    }

    services.databacker-mysql-backup = {
      enable = true;
      cron = "15 1 * * *"
    };
}
```

This will backup *all* schemas in the local mysql instance at 1:15 everyday. The
backups will be stored in `/var/backup/mysql`, and will *NOT* be pruned by
default.
