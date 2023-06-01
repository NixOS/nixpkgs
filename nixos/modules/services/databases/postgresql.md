# PostgreSQL {#module-postgresql}

<!-- FIXME: render nicely -->
<!-- FIXME: source can be added automatically -->

*Source:* {file}`modules/services/databases/postgresql.nix`

*Upstream documentation:* <http://www.postgresql.org/docs/>

<!-- FIXME: more stuff, like maintainer? -->

PostgreSQL is an advanced, free relational database.
<!-- MORE -->

## Configuring {#module-services-postgres-configuring}

To enable PostgreSQL, add the following to your {file}`configuration.nix`:
```
services.postgresql.enable = true;
services.postgresql.package = pkgs.postgresql_11;
```
Note that you are required to specify the desired version of PostgreSQL (e.g. `pkgs.postgresql_11`). Since upgrading your PostgreSQL version requires a database dump and reload (see below), NixOS cannot provide a default value for [](#opt-services.postgresql.package) such as the most recent release of PostgreSQL.

<!--
After running {command}`nixos-rebuild`, you can verify
whether PostgreSQL works by running {command}`psql`:

```ShellSession
$ psql
psql (9.2.9)
Type "help" for help.

alice=>
```
-->

By default, PostgreSQL stores its databases in {file}`/var/lib/postgresql/$psqlSchema`. You can override this using [](#opt-services.postgresql.dataDir), e.g.
```
services.postgresql.dataDir = "/data/postgresql";
```

## Upgrading {#module-services-postgres-upgrading}

::: {.note}
The steps below demonstrate how to upgrade from an older version to `pkgs.postgresql_15`.
These instructions are also applicable to other versions.
:::

Major PostgreSQL upgrades require a downtime. This is the case because each major version
has some internal changes in the databases' state during major releases. Because of that,
NixOS places the state into {file}`/var/lib/postgresql/&lt;version&gt;` where each `version`
can be obtained like this:
```
$ nix-instantiate --eval -A postgresql_13.psqlSchema
"13"
```
For an upgrade, the `services.postgresql.upgradeFrom` option can be used:
```
{ config, pkgs, ... }:
{
  services.postgresql = {
    package = pkgs.postgresql_15;

    upgradeFrom = {
      package = pkgs.postgresql_13;

      # You may specify a different location of the old data directory

      # If you had configured it elsewhere. The default is
      # config.services.postgresql.dataDir
      # settings.old-datadir = "/mnt/postgresql/13";

      # No other flags are specified by default.
      # If you want to use the --link option, for instance:
      # settings.link = true;
    };

    # pg_upgrade recommends a vacuum and analyze after an upgrade
    # This is on by default, but it can be disabled:
    # analyzeAfterUpgrade = false;
  };
}
```

The next `nixos-rebuild switch` will restart the postgresql systemd service and do the upgrade during pre-start.
Subsequent restarts of the systemd postgresql service will not attempt another upgrade.
The previous data directory is kept intact and the upgraded state will be in `config.services.postgresql.dataDir`.

`pg_upgrade` also provides the following means of removing the old state. The `upgradeFrom` postgresql option does not do this by default.

     ::: {.warning}
     The next step removes the old state-directory!
     :::

     ```
     $ ./delete_old_cluster.sh
     ```

## Options {#module-services-postgres-options}

A complete list of options for the PostgreSQL module may be found [here](#opt-services.postgresql.enable).

## Plugins {#module-services-postgres-plugins}

Plugins collection for each PostgreSQL version can be accessed with `.pkgs`. For example, for `pkgs.postgresql_11` package, its plugin collection is accessed by `pkgs.postgresql_11.pkgs`:
```ShellSession
$ nix repl '<nixpkgs>'

Loading '<nixpkgs>'...
Added 10574 variables.

nix-repl> postgresql_11.pkgs.<TAB><TAB>
postgresql_11.pkgs.cstore_fdw        postgresql_11.pkgs.pg_repack
postgresql_11.pkgs.pg_auto_failover  postgresql_11.pkgs.pg_safeupdate
postgresql_11.pkgs.pg_bigm           postgresql_11.pkgs.pg_similarity
postgresql_11.pkgs.pg_cron           postgresql_11.pkgs.pg_topn
postgresql_11.pkgs.pg_hll            postgresql_11.pkgs.pgjwt
postgresql_11.pkgs.pg_partman        postgresql_11.pkgs.pgroonga
...
```

To add plugins via NixOS configuration, set `services.postgresql.extraPlugins`:
```
services.postgresql.package = pkgs.postgresql_11;
services.postgresql.extraPlugins = with pkgs.postgresql_11.pkgs; [
  pg_repack
  postgis
];
```

You can build custom PostgreSQL-with-plugins (to be used outside of NixOS) using function `.withPackages`. For example, creating a custom PostgreSQL package in an overlay can look like:
```
self: super: {
  postgresql_custom = self.postgresql_11.withPackages (ps: [
    ps.pg_repack
    ps.postgis
  ]);
}
```

Here's a recipe on how to override a particular plugin through an overlay:
```
self: super: {
  postgresql_11 = super.postgresql_11.override { this = self.postgresql_11; } // {
    pkgs = super.postgresql_11.pkgs // {
      pg_repack = super.postgresql_11.pkgs.pg_repack.overrideAttrs (_: {
        name = "pg_repack-v20181024";
        src = self.fetchzip {
          url = "https://github.com/reorg/pg_repack/archive/923fa2f3c709a506e111cc963034bf2fd127aa00.tar.gz";
          sha256 = "17k6hq9xaax87yz79j773qyigm4fwk8z4zh5cyp6z0sxnwfqxxw5";
        };
      });
    };
  };
}
```

## JIT (Just-In-Time compilation) {#module-services-postgres-jit}

[JIT](https://www.postgresql.org/docs/current/jit-reason.html)-support in the PostgreSQL package
is disabled by default because of the ~300MiB closure-size increase from the LLVM dependency. It
can be optionally enabled in PostgreSQL with the following config option:

```nix
{
  services.postgresql.enableJIT = true;
}
```

This makes sure that the [`jit`](https://www.postgresql.org/docs/current/runtime-config-query.html#GUC-JIT)-setting
is set to `on` and a PostgreSQL package with JIT enabled is used. Further tweaking of the JIT compiler, e.g. setting a different
query cost threshold via [`jit_above_cost`](https://www.postgresql.org/docs/current/runtime-config-query.html#GUC-JIT-ABOVE-COST)
can be done manually via [`services.postgresql.settings`](#opt-services.postgresql.settings).

The attribute-names of JIT-enabled PostgreSQL packages are suffixed with `_jit`, i.e. for each `pkgs.postgresql`
(and `pkgs.postgresql_<major>`) in `nixpkgs` there's also a `pkgs.postgresql_jit` (and `pkgs.postgresql_<major>_jit`).
Alternatively, a JIT-enabled variant can be derived from a given `postgresql` package via `postgresql.withJIT`.
This is also useful if it's not clear which attribute from `nixpkgs` was originally used (e.g. when working with
[`config.services.postgresql.package`](#opt-services.postgresql.package) or if the package was modified via an
overlay) since all modifications are propagated to `withJIT`. I.e.

```nix
with import <nixpkgs> {
  overlays = [
    (self: super: {
      postgresql = super.postgresql.overrideAttrs (_: { pname = "foobar"; });
    })
  ];
};
postgresql.withJIT.pname
```

evaluates to `"foobar"`.
