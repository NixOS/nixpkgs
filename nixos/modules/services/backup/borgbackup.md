# BorgBackup {#module-borgbase}

*Source:* {file}`modules/services/backup/borgbackup.nix`

*Upstream documentation:* <https://borgbackup.readthedocs.io/>

[BorgBackup](https://www.borgbackup.org/) (short: Borg)
is a deduplicating backup program. Optionally, it supports compression and
authenticated encryption.

The main goal of Borg is to provide an efficient and secure way to backup
data. The data deduplication technique used makes Borg suitable for daily
backups since only changes are stored. The authenticated encryption technique
makes it suitable for backups to not fully trusted targets.

## Configuring {#module-services-backup-borgbackup-configuring}

A complete list of options for the Borgbase module may be found
[here](#opt-services.borgbackup.jobs).

## Basic usage for a local backup {#opt-services-backup-borgbackup-local-directory}

A very basic configuration for backing up to a locally accessible directory is:
```nix
{
    opt.services.borgbackup.jobs = {
      rootBackup = {
        paths = "/";
        exclude = [ "/nix" "/path/to/local/repo" ];
        repo = "/path/to/local/repo";
        doInit = true;
        encryption = {
          mode = "repokey";
          passphrase = "secret";
        };
        compression = "auto,lzma";
        startAt = "weekly";
      };
    };
}
```

::: {.warning}
If you do not want the passphrase to be stored in the world-readable
Nix store, use passCommand. You find an example below.
:::

## Create a borg backup server {#opt-services-backup-create-server}

You should use a different SSH key for each repository you write to,
because the specified keys are restricted to running borg serve and can only
access this single repository. You need the output of the generate pub file.

```ShellSession
# sudo ssh-keygen -N '' -t ed25519 -f /run/keys/id_ed25519_my_borg_repo
# cat /run/keys/id_ed25519_my_borg_repo
ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAID78zmOyA+5uPG4Ot0hfAy+sLDPU1L4AiIoRYEIVbbQ/ root@nixos
```

Add the following snippet to your NixOS configuration:
```nix
{
  services.borgbackup.repos = {
    my_borg_repo = {
      authorizedKeys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAID78zmOyA+5uPG4Ot0hfAy+sLDPU1L4AiIoRYEIVbbQ/ root@nixos"
      ] ;
      path = "/var/lib/my_borg_repo" ;
    };
  };
}
```

## Backup to the borg repository server {#opt-services-backup-borgbackup-remote-server}

The following NixOS snippet creates an hourly backup to the service
(on the host nixos) as created in the section above. We assume
that you have stored a secret passphrasse in the file
{file}`/run/keys/borgbackup_passphrase`, which should be only
accessible by root

```nix
{
  services.borgbackup.jobs = {
    backupToLocalServer = {
      paths = [ "/etc/nixos" ];
      doInit = true;
      repo =  "borg@nixos:." ;
      encryption = {
        mode = "repokey-blake2";
        passCommand = "cat /run/keys/borgbackup_passphrase";
      };
      environment = { BORG_RSH = "ssh -i /run/keys/id_ed25519_my_borg_repo"; };
      compression = "auto,lzma";
      startAt = "hourly";
    };
  };
}
```

The following few commands (run as root) let you test your backup.
```
> nixos-rebuild switch
...restarting the following units: polkit.service
> systemctl restart borgbackup-job-backupToLocalServer
> sleep 10
> systemctl restart borgbackup-job-backupToLocalServer
> export BORG_PASSPHRASE=topSecrect
> borg list --rsh='ssh -i /run/keys/id_ed25519_my_borg_repo' borg@nixos:.
nixos-backupToLocalServer-2020-03-30T21:46:17 Mon, 2020-03-30 21:46:19 [84feb97710954931ca384182f5f3cb90665f35cef214760abd7350fb064786ac]
nixos-backupToLocalServer-2020-03-30T21:46:30 Mon, 2020-03-30 21:46:32 [e77321694ecd160ca2228611747c6ad1be177d6e0d894538898de7a2621b6e68]
```

## Backup to a hosting service {#opt-services-backup-borgbackup-borgbase}

Several companies offer [(paid) hosting services](https://www.borgbackup.org/support/commercial.html)
for Borg repositories.

To backup your home directory to borgbase you have to:

  - Generate a SSH key without a password, to access the remote server. E.g.

        sudo ssh-keygen -N '' -t ed25519 -f /run/keys/id_ed25519_borgbase

  - Create the repository on the server by following the instructions for your
    hosting server.
  - Initialize the repository on the server. Eg.

        sudo borg init --encryption=repokey-blake2  \
            --rsh "ssh -i /run/keys/id_ed25519_borgbase" \
            zzz2aaaaa@zzz2aaaaa.repo.borgbase.com:repo

  - Add it to your NixOS configuration, e.g.

        {
            services.borgbackup.jobs = {
            my_Remote_Backup = {
                paths = [ "/" ];
                exclude = [ "/nix" "'**/.cache'" ];
                repo =  "zzz2aaaaa@zzz2aaaaa.repo.borgbase.com:repo";
                  encryption = {
                  mode = "repokey-blake2";
                  passCommand = "cat /run/keys/borgbackup_passphrase";
                };
                environment = { BORG_RSH = "ssh -i /run/keys/id_ed25519_borgbase"; };
                compression = "auto,lzma";
                startAt = "daily";
            };
          };
        }}

## Vorta backup client for the desktop {#opt-services-backup-borgbackup-vorta}

Vorta is a backup client for macOS and Linux desktops. It integrates the
mighty BorgBackup with your desktop environment to protect your data from
disk failure, ransomware and theft.

It can be installed in NixOS e.g. by adding `pkgs.vorta`
to [](#opt-environment.systemPackages).

Details about using Vorta can be found under
[https://vorta.borgbase.com](https://vorta.borgbase.com/usage) .
