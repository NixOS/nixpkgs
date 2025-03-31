# ownCloud Infinite Scale {#module-services-ocis}

[ownCloud Infinite Scale](https://owncloud.dev/ocis/) (oCIS) is an open-source,
modern file-sync and sharing platform. It is a ground-up rewrite of the well-known PHP based ownCloud server.

The server setup can be automated using
[services.ocis](#opt-services.ocis.enable). The desktop client is packaged at
`pkgs.owncloud-client`.

The current default version is `ocis_71-bin` (oCIS 7.1.x).

## Basic usage {#module-services-ocis-basic-usage}

oCIS is a golang application and does not require an HTTP server (such as nginx)
in front of it, though you may optionally use one if you will.

oCIS is configured using a combination of yaml and environment variables. It is
recommended to familiarize yourself with upstream's available configuration
options and deployment instructions:

* [Getting Started](https://owncloud.dev/ocis/getting-started/)
* [Configuration](https://owncloud.dev/ocis/config/)
* [Basic Setup](https://owncloud.dev/ocis/deployment/basic-remote-setup/)

A very basic configuration may look like this:
```
{ pkgs, ... }:
{
  services.ocis = {
    enable = true;
    configDir = "/etc/ocis/config";
  };
}
```

This will start the oCIS server and make it available at `https://localhost:9200`

However to make this configuration work you will need generate a configuration.
You can do this with:

```console
$ nix-shell -p ocis_71-bin
$ mkdir scratch/
$ cd scratch/
$ ocis init --config-path . --admin-password "changeme"
```

You may need to pass `--insecure true` or provide the `OCIS_INSECURE = true;` to
[`services.ocis.environment`][mod-envFile], if TLS certificates are generated
and managed externally (e.g. if you are using oCIS behind reverse proxy).

If you want to manage the config file in your nix configuration, then it is
encouraged to use a secrets manager like sops-nix or agenix.

Be careful not to write files containing secrets to the globally readable nix
store.

Please note that current NixOS module for oCIS is configured to run in
`fullstack` mode (sometimes called single-process mode), which starts all the
services for owncloud on single instance. This will start multiple ocis
services and listen on multiple other ports.

Upstream [has a list of services and their ports](https://doc.owncloud.com/ocis/7.1/deployment/services/ports-used.html).

## Configuration via environment variables {#module-services-ocis-configuration-via-environment-variables }

You can also eschew the config file entirely and pass everything to oCIS via
environment variables. For this make use of
[`services.ocis.environment`][mod-env] for non-sensitive
values, and
[`services.ocis.environmentFile`][mod-envFile] for
sensitive values.

Configuration in (`services.ocis.environment`)[mod-env] overrides those from
[`services.ocis.environmentFile`][mod-envFile] and will have highest
precedence


[mod-env]: #opt-services.ocis.environment
[mod-envFile]: #opt-services.ocis.environmentFile


## Upgrading {#module-services-ocis-upgrading}

When upgrading oCIS, it's crucial to follow the proper upgrade path to ensure
data integrity and system stability. Please follow these guidelines:

- **Always back up your data before upgrading**. This includes your oCIS
   configuration, database, and user files.

- **Upgrade sequentially through each major.minor version**. You cannot skip
   versions listed in the [upstream upgrade
   documentation](https://doc.owncloud.com/ocis/next/migration/upgrading-ocis.html).
   For example, to upgrade from version 3.0.0 to 7.1.0, you must upgrade to
   4.0.0, then 5.0.0, then 7.0.0, and finally to 7.1.0. Note that you can skip
   versions not listed in the upgrade documentation (for example, 6.x is not
   listed, so it can be skipped).

- **Read the upstream documentation for each upgrade step**. Some upgrades
   require manual intervention due to breaking changes or new configuration
   requirements, while others don't. Even if an upgrade appears
   straightforward, you should still follow the step-by-step process.

- **Use the appropriate package for each version**. Maintainers of oCIS in
   nixpkgs will ensure there exists an `ocis_X-bin` package in sequence for as
   long as possible.

- **Use the `ocisadm` tool**. The NixOS module provides the `ocisadm` tool,
  which is a wrapper around the normal `ocis` cli tool, but when executed is
  ran in the same systemd environment as the ocis service, so it is run as the
  correct user and has access to the full configuration.

For example to upgrade to version 5.0.x to 7.1.x, you must upgrade to 7.0.x in
between. This would look like:

```nix
services.ocis = {
  enable = true;
  package = pkgs.ocis_5-bin; # Starting at version 5.0.x
  # ...other configuration...
};
```

Then when ready to upgrade and AFTER performing a backup:

```nix
services.ocis = {
  enable = true;
  package = pkgs.ocis_70-bin; # Upgrade to version 7.0.x
  # ...other configuration...
};
```

Then follow the [specific upgrade
instructions](https://doc.owncloud.com/ocis/next/migration/upgrading_5.0.x_7.0.0.html#update-config-settings).
When prompted to run `ocis init --diff` you should run `sudo ocisadm init
--diff` instead.

Then after ensuring 7.0.x upgrades starts properly:

```nix
services.ocis = {
  enable = true;
  package = pkgs.ocis_71-bin; # Final upgrade to version 7.1.x
  # ...other configuration...
};
```

Before performing any upgrade, thoroughly familiarize yourself with the
[upstream upgrade
documentation](https://doc.owncloud.com/ocis/next/migration/upgrading-ocis.html)
for each specific version transition.


## Maintainer information {#module-services-ocis-maintainer-info}

We must provide a clean upgrade path for oCIS. This means that there *must*
exist a package for every major *and* minor version, since you cannot move more
than one major+minor version forward in a single upgrade.

Patch-level upgrades are no problem they can be done in-place and should be
backported to stable branches.

Major and minor releases should be added as a new package in `nixpkgs` named
like the python package with the major and minor version with the `.` removed
(i.e., version 7.1.0 is `pkgs.ocis_71-bin`).

To provide simple upgrade paths it's generally useful to backport those as well
to stable branches. As long as the package-default isn't altered, this won't
break existing installations.

After that, the version warning in the nixos module should be updated to make
sure that the [package](#opt-services.ocis.package)-option selects the latest
version on new installations.

If major-releases are abandoned by upstream, we should first check if those are
needed in NixOS for a safe upgrade-path before removing those. In those cases
we should keep the affected packages, but mark them as insecure in an
expression like this (in `<nixpkgs/pkgs/by-name/oc/ocis_X-bin/package.nix>`):

```nix
/* ... */
  meta = with lib; {
    /* ... */
    sourceProvenance = [ sourceTypes.binaryNativeCode ];
    mainProgram = "ocis";
    knownVulnerabilities = ["oCIS version ${version} is EOL"];
  };
/* ... */
```
