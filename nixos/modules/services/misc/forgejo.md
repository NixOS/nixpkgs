# Forgejo {#module-forgejo}

Forgejo is a soft-fork of gitea, with strong community focus, as well
as on self-hosting and federation. [Codeberg](https://codeberg.org) is
deployed from it.

See [upstream docs](https://forgejo.org/docs/latest/).

The method of choice for running forgejo is using [`services.forgejo`](#opt-services.forgejo.enable).

::: {.warning}
Running forgejo using `services.gitea.package = pkgs.forgejo` is no longer
recommended.
If you experience issues with your instance using `services.gitea`,
**DO NOT** report them to the `services.gitea` module maintainers.
**DO** report them to the `services.forgejo` module maintainers instead.
:::

## Migration from Gitea {#module-forgejo-migration-gitea}

::: {.note}
Migrating is, while not strictly necessary at this point, highly recommended.
Both modules and projects are likely to diverge further with each release.
Which might lead to an even more involved migration.
:::

### Full-Migration {#module-forgejo-migration-gitea-default}

This will migrate the state directory (data), rename and chown the database and
delete the gitea user.

::: {.note}
This will also change the git remote ssh-url user from `gitea@` to `forgejo@`,
when using the host's openssh server (default) instead of the integrated one.
:::

Instructions for PostgreSQL (default). Adapt accordingly for other databases:

```sh
systemctl stop gitea
mv /var/lib/gitea /var/lib/forgejo
runuser -u postgres -- psql -c '
  ALTER USER gitea RENAME TO forgejo;
  ALTER DATABASE gitea RENAME TO forgejo;
'
nixos-rebuild switch
systemctl stop forgejo
chown -R forgejo:forgejo /var/lib/forgejo
systemctl restart forgejo
```

### Alternatively, keeping the gitea user {#module-forgejo-migration-gitea-impersonate}

Alternatively, instead of renaming the database, copying the state folder and
changing the user, the forgejo module can be set up to re-use the old storage
locations and database, instead of having to copy or rename them.
Make sure to disable `services.gitea`, when doing this.

```nix
services.gitea.enable = false;

services.forgejo = {
  enable = true;
  user = "gitea";
  group = "gitea";
  stateDir = "/var/lib/gitea";
  database.name = "gitea";
  database.user = "gitea";
};

users.users.gitea = {
  home = "/var/lib/gitea";
  useDefaultShell = true;
  group = "gitea";
  isSystemUser = true;
};

users.groups.gitea = {};
```
