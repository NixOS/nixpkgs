# Garage {#module-services-garage}

[Garage](https://garagehq.deuxfleurs.fr/)
is an open-source, self-hostable S3 store, simpler than MinIO, for geodistributed stores.
The server setup can be automated using
[services.garage](#opt-services.garage.enable). A
 client configured to your local Garage instance is available in
 the global environment as `garage-manage`.

The current default by NixOS is `garage_0_8` which is also the latest
major version available.

## General considerations on upgrades {#module-services-garage-upgrade-scenarios}

Garage provides a cookbook documentation on how to upgrade:
<https://garagehq.deuxfleurs.fr/documentation/cookbook/upgrading/>

::: {.warning}
Garage has two types of upgrades: patch-level upgrades and minor/major version upgrades.

In all cases, you should read the changelog and ideally test the upgrade on a staging cluster.

Checking the health of your cluster can be achieved using `garage-manage repair`.
:::

::: {.warning}
Until 1.0 is released, patch-level upgrades are considered as minor version upgrades.
Minor version upgrades are considered as major version upgrades.
i.e. 0.6 to 0.7 is a major version upgrade.
:::

  - **Straightforward upgrades (patch-level upgrades).**
    Upgrades must be performed one by one, i.e. for each node, stop it, upgrade it : change [stateVersion](#opt-system.stateVersion) or [services.garage.package](#opt-services.garage.package), restart it if it was not already by switching.
  - **Multiple version upgrades.**
    Garage do not provide any guarantee on moving more than one major-version forward.
    E.g., if you're on `0.7`, you cannot upgrade to `0.9`.
    You need to upgrade to `0.8` first.
    As long as [stateVersion](#opt-system.stateVersion) is declared properly,
    this is enforced automatically. The module will issue a warning to remind the user to upgrade to latest
    Garage *after* that deploy.

## Advanced upgrades (minor/major version upgrades) {#module-services-garage-advanced-upgrades}

Here are some baseline instructions to handle advanced upgrades in Garage, when in doubt, please refer to upstream instructions.

  - Disable API and web access to Garage.
  - Perform `garage-manage repair --all-nodes --yes tables` and `garage-manage repair --all-nodes --yes blocks`.
  - Verify the resulting logs and check that data is synced properly between all nodes.
    If you have time, do additional checks (`scrub`, `block_refs`, etc.).
  - Check if queues are empty by `garage-manage stats` or through monitoring tools.
  - Run `systemctl stop garage` to stop the actual Garage version.
  - Backup the metadata folder of ALL your nodes, e.g. for a metadata directory (the default one) in `/var/lib/garage/meta`,
    you can run `pushd /var/lib/garage; tar -acf meta-v0.7.tar.zst meta/; popd`.
  - Run the offline migration: `nix-shell -p garage_0_8 --run "garage offline-repair --yes"`, this can take some time depending on how many objects are stored in your cluster.
  - Bump Garage version in your NixOS configuration, either by changing [stateVersion](#opt-system.stateVersion) or bumping [services.garage.package](#opt-services.garage.package), this should restart Garage automatically.
  - Perform `garage-manage repair --all-nodes --yes tables` and `garage-manage repair --all-nodes --yes blocks`.
  - Wait for a full table sync to run.

Your upgraded cluster should be in a working state, re-enable API and web access.

## Maintainer information {#module-services-garage-maintainer-info}

As stated in the previous paragraph, we must provide a clean upgrade-path for Garage
since it cannot move more than one major version forward on a single upgrade. This chapter
adds some notes how Garage updates should be rolled out in the future.
This is inspired from how Nextcloud does it.

While patch-level updates are no problem and can be done directly in the
package-expression (and should be backported to supported stable branches after that),
major-releases should be added in a new attribute (e.g. Garage `v0.8.0`
should be available in `nixpkgs` as `pkgs.garage_0_8_0`).
To provide simple upgrade paths it's generally useful to backport those as well to stable
branches. As long as the package-default isn't altered, this won't break existing setups.
After that, the versioning-warning in the `garage`-module should be
updated to make sure that the
[package](#opt-services.garage.package)-option selects the latest version
on fresh setups.

If major-releases will be abandoned by upstream, we should check first if those are needed
in NixOS for a safe upgrade-path before removing those. In that case we should keep those
packages, but mark them as insecure in an expression like this (in
`<nixpkgs/pkgs/tools/filesystem/garage/default.nix>`):
```nix
/* ... */
{
  garage_0_7_3 = generic {
    version = "0.7.3";
    sha256 = "0000000000000000000000000000000000000000000000000000";
    eol = true;
  };
}
```

Ideally we should make sure that it's possible to jump two NixOS versions forward:
i.e. the warnings and the logic in the module should guard a user to upgrade from a
Garage on e.g. 22.11 to a Garage on 23.11.
