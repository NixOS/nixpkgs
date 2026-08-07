# Tandoor Recipes {#module-services-tandoor-recipes}

## Remediating insecure `MEDIA_ROOT` for installations prior to 26.05 {#module-services-tandoor-recipes-migrating-media}

Tandoor Recipes installations initialized with `system.stateVersion < 26.05`
may suffer from a security vulnerability. To remediate this issue, apply one of
the recommendations below.

See [NixOS/nixpkgs#338339](https://github.com/NixOS/nixpkgs/issues/338339) and
[GHSA-g8w3-p77x-mmxh](https://github.com/NixOS/nixpkgs/security/advisories/GHSA-g8w3-p77x-mmxh)
for some background.

### Recommended: Move `MEDIA_ROOT` into a subdirectory {#module-services-tandoor-recipes-migrating-media-option-move}

The issue is only present when `MEDIA_ROOT` is the same as the data directory. Moving it into a subdirectory of `/var/lib/tandoor-recipes` remediates this and any similar issues in the future.

1. Stop the currently running service: `systemctl stop tandoor-recipes.service`
2. Create a media folder. NixOS `26.05` creates the media path at `/var/lib/tandoor-recipes/media` by default, but you may choose any other path as well. `mkdir -p /var/lib/tandoor-recipes/media`
3. Move existing media to the new path: `mv /var/lib/tandoor-recipes/{files,recipes} /var/lib/tandoor-recipes/media`
4. Set `services.tandoor-recipes.extraConfig.MEDIA_ROOT = "/var/lib/tandoor-recipes/media";` in your NixOS configuration (not needed if `system.stateVersion >= 26.05`).
5. If not using `GUNICORN_MEDIA`, update your reverse proxy / web server configuration accordingly.
6. Rebuild and switch!

These changes can be reverted by moving the files back into the state directory.

### Not recommended: Switch to PostgreSQL {#module-services-tandoor-recipes-migrating-media-option-postgresql}

When using an external database like PostgreSQL (the only other option available in Tandoor Recipes) this issue does not manifest.

A simple PostgreSQL configuration can be enabled using the option
[`services.tandoor-recipes.database.createLocally`](https://search.nixos.org/options?channel=unstable&show=services.tandoor-recipes.database.createLocally).

Note that this will require migrating the existing database to PostgreSQL. Refer to the [upstream documentation](https://docs.tandoor.dev/system/migration_sqlite-postgres/) for this procedure. It is important to delete or move the `db.sqlite3` file out of the media path, after this has been done.

More information on configuring PostgreSQL can be found in the [upstream documentation](https://docs.tandoor.dev/system/configuration/#database).

Set the following option to ignore the evaluation warnings once `db.sqlite3` has been deleted.

```nix
{
  services.tandoor-recipes.extraConfig.MEDIA_ROOT = "/var/lib/tandoor-recipes";
}
```

As future releases of Tandoor Recipes could add additional files to the data
directory, this is not a future-proof solution.

### Not recommended: Disallow access to `db.sqlite3` {#module-services-tandoor-recipes-migrating-media-option-disallow-access}

When using a web server like nginx, access to this file can be disabled.

As future releases of Tandoor Recipes could add additional files to the data
directory, this is not a future-proof solution.
