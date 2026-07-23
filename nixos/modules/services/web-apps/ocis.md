# ownCloud Infinite Scale {#module-services-ocis}

[ownCloud Infinite Scale](https://owncloud.dev/ocis/) (oCIS) is a modern
file-sync and sharing platform and a ground-up rewrite of the PHP-based ownCloud server.

The server setup can be automated using
[services.ocis](#opt-services.ocis.enable). The desktop client is packaged as
`pkgs.owncloud-client`.

For new NixOS installations with `system.stateVersion` set to 26.11 or later,
the default server package is `ocis_81-bin` (oCIS 8.1.x).
Older installations retain `ocis_5-bin` until an administrator explicitly
performs every required upgrade step.

## Basic usage {#module-services-ocis-basic-usage}

oCIS is a Go application and does not require an HTTP server such as nginx in
front of it, although a reverse proxy can be used.

oCIS is configured using YAML and environment variables.
Review upstream's configuration and deployment documentation before deploying it:

- [Getting Started](https://owncloud.dev/ocis/getting-started/)
- [Configuration](https://owncloud.dev/ocis/config/)
- [Basic Setup](https://owncloud.dev/ocis/deployment/basic-remote-setup/)

A minimal configuration looks like this:

```nix
{
  services.ocis = {
    enable = true;
    configDir = "/etc/ocis/config";
  };
}
```

This starts the oCIS server at `https://localhost:9200`.

Generate an initial configuration with the same package selected by the NixOS module:

```console
$ nix-shell -p ocis_81-bin
$ mkdir scratch
$ cd scratch
$ ocis init --config-path . --admin-password "changeme"
```

You may need to pass `--insecure true` or set `OCIS_INSECURE = "true"` in
[`services.ocis.environment`][mod-env] when TLS is terminated by a reverse proxy.

If the configuration is managed through Nix, keep secrets outside the globally
readable Nix store with a secrets manager such as sops-nix or agenix and load
them through [`services.ocis.environmentFile`][mod-envFile].

The NixOS module runs oCIS in `fullstack` mode, also called single-process mode.
This starts all ownCloud services in one oCIS process.
See upstream's [service port documentation](https://doc.owncloud.com/ocis/next/deployment/services/ports-used.html)
for the internal listeners used by that process.

## Configuration via environment variables {#module-services-ocis-configuration-via-environment-variables}

You can omit the YAML configuration and configure oCIS entirely through
environment variables.
Use [`services.ocis.environment`][mod-env] for non-sensitive values and
[`services.ocis.environmentFile`][mod-envFile] for sensitive values.

Values in [`services.ocis.environment`][mod-env] override values from
[`services.ocis.environmentFile`][mod-envFile].

## Upgrading {#module-services-ocis-upgrading}

Back up the oCIS configuration, metadata, and user data before every upgrade.
Read the [upstream migration documentation](https://doc.owncloud.com/ocis/next/migration/upgrading-ocis.html)
for every transition before changing the package.

Upstream requires administrators to apply every production upgrade step in order.
Nixpkgs therefore retains one binary package for each required production line:

| Current package | Next package | Upstream transition |
|---|---|---|
| `ocis_5-bin` | `ocis_70-bin` | 5.0.x to 7.0.x |
| `ocis_70-bin` | `ocis_71-bin` | 7.0.x to 7.1.x |
| `ocis_71-bin` | `ocis_72-bin` | 7.1.x to 7.2.x |
| `ocis_72-bin` | `ocis_73-bin` | 7.2.x to 7.3.x |
| `ocis_73-bin` | `ocis_80-bin` | 7.3.x to 8.0.x |
| `ocis_80-bin` | `ocis_81-bin` | 8.0.x to 8.1.x |

The 6.x releases were rolling releases and are incorporated into the documented
5.0.x to 7.0.x production transition.
Do not skip any other row in the table.

For example, an installation still using the pre-26.11 default starts with:

```nix
{
  services.ocis.package = pkgs.ocis_5-bin;
}
```

After backing up and completing the upstream 5.0.x to 7.0.x preparation, select:

```nix
{
  services.ocis.package = pkgs.ocis_70-bin;
}
```

Before starting the upgraded service, use `sudo ocisadm init --diff` when the
upstream instructions ask you to inspect required configuration changes.
The `ocisadm` wrapper runs the selected oCIS executable with the service's user,
group, state directory, environment, and environment file.
When an explicit `services.ocis.configDir` is configured, the wrapper changes
to that directory before running the command.

Repeat the backup, migration instructions, package change, and validation for
each remaining row until the desired production release is reached.

`system.stateVersion` only preserves the package default for existing systems.
Changing it does not perform an oCIS migration and must not be used to skip the
explicit package sequence.

## Maintainer information {#module-services-ocis-maintainer-info}

Keep a package for every production major and minor release that appears in the
upstream migration sequence.
Name a package by removing the dot from the production line, for example
`ocis_81-bin` for oCIS 8.1.x.

Patch-level updates remain within the corresponding package and should be
backported to supported stable Nixpkgs branches when appropriate.
A new production line requires a new package rather than changing an older
intermediate package to that line.

Only change the module's `system.stateVersion`-gated default while the target
NixOS release is still under development.
Existing NixOS releases must retain their original default so that a channel
update cannot silently skip an oCIS migration.

Do not remove an old package merely because upstream has stopped maintaining it
if it is still required for a supported upgrade path.
Mark verified end-of-life or vulnerable releases through package metadata and
document how administrators can temporarily permit the package while migrating.

[mod-env]: #opt-services.ocis.environment
[mod-envFile]: #opt-services.ocis.environmentFile
