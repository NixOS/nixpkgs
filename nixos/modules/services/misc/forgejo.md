# Forgejo {#module-forgejo}

Forgejo is a soft-fork of gitea, with strong community focus, as well
as on self-hosting and federation. [Codeberg](https://codeberg.org) is
deployed from it.

See [upstream docs](https://forgejo.org/docs/latest/)

## Migration from Gitea {#module-forgejo-migration-gitea}

The method of choice for running forgejo used to be with the
`services.gitea` module. For migrating such a setup to the
`services.forgejo` module:

### for default options

for PostgreSQL, adapt accordingly on other DBs

**NOTE:** this will also change git url user from `gitea@` to `forgejo@`

```sh
systemctl stop gitea
mv /var/lib/gitea /var/lib/forgejo
runuser -u postgres -- psql -c '
  ALTER USER gitea RENAME TO forgejo;
  ALTER DATABASE gitea RENAME TO forgejo;
'
nixos-rebuild switch
chown -R forgejo:forgejo /var/lib/forgejo
systemctl restart forgejo
```

### impersonating gitea

Alternatively, instead of renaming the database, the state folder and
changing the user, the forgejo module can be set up to directly work
with gitea state. Be careful to disable `services.gitea`, when doing
this.

```nix
services.forgejo = {
  enable = true;
  user = "gitea";
  group = "gitea";
  stateDir = "/var/lib/gitea";
  database.name = "gitea";
  database.user = "gitea";
};
```
