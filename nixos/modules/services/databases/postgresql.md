# PostgreSQL {#module-postgresql}

<!-- FIXME: render nicely -->
<!-- FIXME: source can be added automatically -->

*Source:* {file}`modules/services/databases/postgresql.nix`

*Upstream documentation:* <https://www.postgresql.org/docs/>

<!-- FIXME: more stuff, like maintainer? -->

PostgreSQL is an advanced, free, relational database.
<!-- MORE -->

## Configuring {#module-services-postgres-configuring}

To enable PostgreSQL, add the following to your {file}`configuration.nix`:
```nix
{
  services.postgresql.enable = true;
  services.postgresql.package = pkgs.postgresql_15;
}
```

The default PostgreSQL version is approximately the latest major version available on the NixOS release matching your [`system.stateVersion`](#opt-system.stateVersion).
This is because PostgreSQL upgrades require a manual migration process (see below).
Hence, upgrades must happen by setting [`services.postgresql.package`](#opt-services.postgresql.package) explicitly.

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
```nix
{ services.postgresql.dataDir = "/data/postgresql"; }
```

## Initializing {#module-services-postgres-initializing}

As of NixOS 24.05,
`services.postgresql.ensureUsers.*.ensurePermissions` has been
removed, after a change to default permissions in PostgreSQL 15
invalidated most of its previous use cases:

- In psql < 15, `ALL PRIVILEGES` used to include `CREATE TABLE`, where
  in psql >= 15 that would be a separate permission
- psql >= 15 instead gives only the database owner create permissions
- Even on psql < 15 (or databases migrated to >= 15), it is
  recommended to manually assign permissions along these lines
  - <https://www.postgresql.org/docs/release/15.0/>
  - <https://www.postgresql.org/docs/15/ddl-schemas.html#DDL-SCHEMAS-PRIV>

### Assigning ownership {#module-services-postgres-initializing-ownership}

Usually, the database owner should be a database user of the same
name. This can be done with
`services.postgresql.ensureUsers.*.ensureDBOwnership = true;`.

If the database user name equals the connecting system user name,
postgres by default will accept a passwordless connection via unix
domain socket. This makes it possible to run many postgres-backed
services without creating any database secrets at all.

### Assigning extra permissions {#module-services-postgres-initializing-extra-permissions}

For many cases, it will be enough to have the database user be the
owner. Until `services.postgresql.ensureUsers.*.ensurePermissions` has
been re-thought, if more users need access to the database, please use
one of the following approaches:

**WARNING:** `services.postgresql.initialScript` is not recommended
for `ensurePermissions` replacement, as that is *only run on first
start of PostgreSQL*.

**NOTE:** all of these methods may be obsoleted, when `ensure*` is
reworked, but it is expected that they will stay viable for running
database migrations.

**NOTE:** please make sure that any added migrations are idempotent (re-runnable).

#### in database's setup `postStart` {#module-services-postgres-initializing-extra-permissions-superuser-post-start}

`ensureUsers` is run in `postgresql-setup`, so this is where `postStart` must be added to:

```nix
{
  systemd.services.postgresql-setup.postStart = ''
    psql service1 -c 'GRANT SELECT ON ALL TABLES IN SCHEMA public TO "extraUser1"'
    psql service1 -c 'GRANT SELECT ON ALL SEQUENCES IN SCHEMA public TO "extraUser1"'
    # ....
  '';
}
```

#### in intermediate oneshot service {#module-services-postgres-initializing-extra-permissions-superuser-oneshot}

Make sure to run this service after `postgresql.target`, not `postgresql.service`.

They differ in two aspects:
- `postgresql.target` includes `postgresql-setup`, so users managed via `ensureUsers` are already created.
- `postgresql.target` will wait until PostgreSQL is in read-write mode after restoring from backup, while `postgresql.service` will already be ready when PostgreSQL is still recovering in read-only mode.

Both can lead to unexpected errors either during initial database creation or restore, when using `postgresql.service`.

```nix
{
  systemd.services."migrate-service1-db1" = {
    serviceConfig.Type = "oneshot";
    requiredBy = "service1.service";
    before = "service1.service";
    after = "postgresql.target";
    serviceConfig.User = "postgres";
    environment.PGPORT = toString services.postgresql.settings.port;
    path = [ postgresql ];
    script = ''
      psql service1 -c 'GRANT SELECT ON ALL TABLES IN SCHEMA public TO "extraUser1"'
      psql service1 -c 'GRANT SELECT ON ALL SEQUENCES IN SCHEMA public TO "extraUser1"'
      # ....
    '';
  };
}
```

## Authentication {#module-services-postgres-authentication}

Local connections are made through unix sockets by default and support [peer authentication](https://www.postgresql.org/docs/current/auth-peer.html).
This allows system users to login with database roles of the same name.
For example, the `postgres` system user is allowed to login with the database role `postgres`.

System users and database roles might not always match.
In this case, to allow access for a service, you can create a [user name map](https://www.postgresql.org/docs/current/auth-username-maps.html) between system roles and an existing database role.

### User Mapping {#module-services-postgres-authentication-user-mapping}

Assume that your app creates a role `admin` and you want the `root` user to be able to login with it.
You can then use [](#opt-services.postgresql.identMap) to define the map and [](#opt-services.postgresql.authentication) to enable it:

```nix
{
  services.postgresql = {
    identMap = ''
      admin root admin
    '';
    authentication = ''
      local all admin peer map=admin
    '';
  };
}
```

::: {.warning}
To avoid conflicts with other modules, you should never apply a map to `all` roles.
Because PostgreSQL will stop on the first matching line in `pg_hba.conf`, a line matching all roles would lock out other services.
Each module should only manage user maps for the database roles that belong to this module.
Best practice is to name the map after the database role it manages to avoid name conflicts.
:::

## Upgrading {#module-services-postgres-upgrading}

::: {.note}
The steps below demonstrate how to upgrade from an older version to `pkgs.postgresql_13`.
These instructions are also applicable to other versions.
:::

Major PostgreSQL upgrades require a downtime and a few imperative steps to be called. This is the case because
each major version has some internal changes in the databases' state. Because of that,
NixOS places the state into {file}`/var/lib/postgresql/&lt;version&gt;` where each `version`
can be obtained like this:
```
$ nix-instantiate --eval -A postgresql_13.psqlSchema
"13"
```
For an upgrade, a script like this can be used to simplify the process:
```nix
{
  config,
  lib,
  pkgs,
  ...
}:
{
  environment.systemPackages = [
    (
      let
        # XXX specify the postgresql package you'd like to upgrade to.
        # Do not forget to list the extensions you need.
        newPostgres = pkgs.postgresql_13.withPackages (pp: [
          # pp.plv8
        ]);
        cfg = config.services.postgresql;
      in
      pkgs.writeScriptBin "upgrade-pg-cluster" ''
        set -eux
        # XXX it's perhaps advisable to stop all services that depend on postgresql
        systemctl stop postgresql

        export NEWDATA="/var/lib/postgresql/${newPostgres.psqlSchema}"
        export NEWBIN="${newPostgres}/bin"

        export OLDDATA="${cfg.dataDir}"
        export OLDBIN="${cfg.finalPackage}/bin"

        install -d -m 0700 -o postgres -g postgres "$NEWDATA"
        cd "$NEWDATA"
        sudo -u postgres "$NEWBIN/initdb" -D "$NEWDATA" ${lib.escapeShellArgs cfg.initdbArgs}

        sudo -u postgres "$NEWBIN/pg_upgrade" \
          --old-datadir "$OLDDATA" --new-datadir "$NEWDATA" \
          --old-bindir "$OLDBIN" --new-bindir "$NEWBIN" \
          "$@"
      ''
    )
  ];
}
```

The upgrade process is:

  1. Add the above to your {file}`configuration.nix` and rebuild. Alternatively, add that into a separate file and reference it in the `imports` list.
  2. Login as root (`sudo su -`).
  3. Run `upgrade-pg-cluster`. This will stop the old postgresql cluster, initialize a new one and migrate the old one to the new one. You may supply arguments like `--jobs 4` and `--link` to speedup the migration process. See <https://www.postgresql.org/docs/current/pgupgrade.html> for details.
  4. Change the postgresql package in NixOS configuration to the one you were upgrading to via [](#opt-services.postgresql.package). Rebuild NixOS. This should start the new postgres version using the upgraded data directory and all services you stopped during the upgrade.
  5. After the upgrade it's advisable to analyze the new cluster:

       - For PostgreSQL ≥ 14, use the `vacuumdb` command printed by the upgrades script.
       - For PostgreSQL < 14, run (as `su -l postgres` in the [](#opt-services.postgresql.dataDir), in this example {file}`/var/lib/postgresql/13`):

         ```
         $ ./analyze_new_cluster.sh
         ```

     ::: {.warning}
     The next step removes the old state-directory!
     :::

     ```
     $ ./delete_old_cluster.sh
     ```

## Versioning and End-of-Life {#module-services-postgres-versioning}

PostgreSQL's versioning policy is described [here](https://www.postgresql.org/support/versioning/). TLDR:

- Each major version is supported for 5 years.
- Every three months there will be a new minor release, containing bug and security fixes.
- For criticial/security fixes there could be more minor releases inbetween. This happens *very* infrequently.
- After five years, a final minor version is released. This usually happens in early November.
- After that a version is considered end-of-life (EOL).
- Around February each year is the first time an EOL-release will not have received regular updates anymore.

Technically, we'd not want to have EOL'ed packages in a stable NixOS release, which is to be supported until one month after the previous release. Thus, with NixOS' release schedule in May and November, the oldest PostgreSQL version in nixpkgs would have to be supported until December. It could be argued that a soon-to-be-EOL-ed version should thus be removed in May for the .05 release already. But since new security vulnerabilities are first disclosed in February of the following year, we agreed on keeping the oldest PostgreSQL major version around one more cycle in [#310580](https://github.com/NixOS/nixpkgs/pull/310580#discussion_r1597284693).

Thus, our release workflow is as follows:

- In May, `nixpkgs` packages the beta release for an upcoming major version. This is packaged for nixos-unstable only and will not be part of any stable NixOS release.
- In September/October the new major version will be released, replacing the beta package in nixos-unstable.
- In November the last minor version for the oldest major will be released.
- Both the current stable .05 release and nixos-unstable should be updated to the latest minor that will usually be released in November.
  - This is relevant for people who need to use this major for as long as possible. In that case its desirable to be able to pin nixpkgs to a commit that still has it, at the latest minor available.
- In November, before branch-off for the .11 release and after the update to the latest minor, the EOL-ed major will be removed from nixos-unstable.

This leaves a small gap of a couple of weeks after the latest minor release and the end of our support window for the .05 release, in which there could be an emergency release to other major versions of PostgreSQL - but not the oldest major we have in that branch. In that case: If we can't trivially patch the issue, we will mark the package/version as insecure **immediately**.

## `pg_config` {#module-services-postgres-pg_config}

`pg_config` is not part of the `postgresql`-package itself.
It is available under `postgresql_<major>.pg_config` and `libpq.pg_config`.
Use the `pg_config` from the postgresql package you're using in your build.

Also, `pg_config` is a shell-script that replicates the behavior of the upstream `pg_config` and ensures at build-time that the output doesn't change.

This approach is done for the following reasons:

* By using a shell script, cross compilation of extensions is made easier.

* The separation allowed a massive reduction of the runtime closure's size.
  Any attempts to move `pg_config` into `$dev` resulted in brittle and more complex solutions
  (see commits [`0c47767`](https://github.com/NixOS/nixpkgs/commit/0c477676412564bd2d5dadc37cf245fe4259f4d9), [`435f51c`](https://github.com/NixOS/nixpkgs/commit/435f51c37faf74375134dfbd7c5a4560da2a9ea7)).

* `pg_config` is only needed to build extensions or in some exceptions for building client libraries linking to `libpq.so`.
  If such a build works without `pg_config`, this is strictly preferable over adding `pg_config` to the build environment.

  With the current approach it's now explicit that this is needed.


## Options {#module-services-postgres-options}

A complete list of options for the PostgreSQL module may be found [here](#opt-services.postgresql.enable).

## Plugins {#module-services-postgres-plugins}

The collection of plugins for each PostgreSQL version can be accessed with `.pkgs`. For example, for the `pkgs.postgresql_15` package, its plugin collection is accessed by `pkgs.postgresql_15.pkgs`:
```ShellSession
$ nix repl '<nixpkgs>'

Loading '<nixpkgs>'...
Added 10574 variables.

nix-repl> postgresql_15.pkgs.<TAB><TAB>
postgresql_15.pkgs.cstore_fdw        postgresql_15.pkgs.pg_repack
postgresql_15.pkgs.pg_auto_failover  postgresql_15.pkgs.pg_safeupdate
postgresql_15.pkgs.pg_bigm           postgresql_15.pkgs.pg_similarity
postgresql_15.pkgs.pg_cron           postgresql_15.pkgs.pg_topn
postgresql_15.pkgs.pg_hll            postgresql_15.pkgs.pgjwt
postgresql_15.pkgs.pg_partman        postgresql_15.pkgs.pgroonga
...
```

To add plugins via NixOS configuration, set `services.postgresql.extensions`:
```nix
{
  services.postgresql.package = pkgs.postgresql_17;
  services.postgresql.extensions =
    ps: with ps; [
      pg_repack
      postgis
    ];
}
```

You can build a custom `postgresql-with-plugins` (to be used outside of NixOS) using the function `.withPackages`. For example, creating a custom PostgreSQL package in an overlay can look like this:
```nix
self: super: {
  postgresql_custom = self.postgresql_17.withPackages (ps: [
    ps.pg_repack
    ps.postgis
  ]);
}
```

Here's a recipe on how to override a particular plugin through an overlay:
```nix
self: super: {
  postgresql_15 = super.postgresql_15 // {
    pkgs = super.postgresql_15.pkgs // {
      pg_repack = super.postgresql_15.pkgs.pg_repack.overrideAttrs (_: {
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

## Procedural Languages {#module-services-postgres-pls}

PostgreSQL ships the additional procedural languages PL/Perl, PL/Python and PL/Tcl as extensions.
They are packaged as plugins and can be made available in the same way as external extensions:
```nix
{
  services.postgresql.extensions =
    ps: with ps; [
      plperl
      plpython3
      pltcl
    ];
}
```

Each procedural language plugin provides a `.withPackages` helper to make language specific packages available at run-time.

For example, to make `python3Packages.base58` available:
```nix
{
  services.postgresql.extensions =
    pgps: with pgps; [ (plpython3.withPackages (pyps: with pyps; [ base58 ])) ];
}
```

This currently works for:
- `plperl` by re-using `perl.withPackages`
- `plpython3` by re-using `python3.withPackages`
- `plr` by exposing `rPackages`
- `pltcl` by exposing `tclPackages`

## JIT (Just-In-Time compilation) {#module-services-postgres-jit}

[JIT](https://www.postgresql.org/docs/current/jit-reason.html)-support in the PostgreSQL package
is disabled by default because of the ~600MiB closure-size increase from the LLVM dependency. It
can be optionally enabled in PostgreSQL with the following config option:

```nix
{ services.postgresql.enableJIT = true; }
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
      postgresql = super.postgresql.overrideAttrs (_: {
        pname = "foobar";
      });
    })
  ];
};
postgresql.withJIT.pname
```

evaluates to `"foobar"`.

## Service hardening {#module-services-postgres-hardening}

The service created by the [`postgresql`-module](#opt-services.postgresql.enable) uses
several common hardening options from `systemd`, most notably:

* Memory pages must not be both writable and executable (this only applies to non-JIT setups).
* A system call filter (see {manpage}`systemd.exec(5)` for details on `@system-service`).
* A stricter default UMask (`0027`).
* Only sockets of type `AF_INET`/`AF_INET6`/`AF_NETLINK`/`AF_UNIX` allowed.
* Restricted filesystem access (private `/tmp`, most of the file-system hierarchy is mounted read-only, only process directories in `/proc` that are owned by the same user).
  * When using [`TABLESPACE`](https://www.postgresql.org/docs/current/manage-ag-tablespaces.html)s, make sure to add the filesystem paths to `ReadWritePaths` like this:
    ```nix
    {
      systemd.services.postgresql.serviceConfig.ReadWritePaths = [ "/path/to/tablespace/location" ];
    }
    ```

The NixOS module also contains necessary adjustments for extensions from `nixpkgs`,
if these are enabled. If an extension or a postgresql feature from `nixpkgs` breaks
with hardening, it's considered a bug.

When using extensions that are not packaged in `nixpkgs`, hardening adjustments may
become necessary.

## Notable differences to upstream {#module-services-postgres-upstream-deviation}

- To avoid circular dependencies between default and -dev outputs, the output of the `pg_config` system view has been removed.
