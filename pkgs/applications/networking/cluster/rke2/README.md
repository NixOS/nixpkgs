# RKE2 Version

RKE2, Kubernetes, and other clustered software have the property of not being able to update
atomically. Most software in Nixpkgs, like for example bash, can be updated as part of a
`nixos-rebuild switch` without having to worry about the old and the new bash interacting in some
way. RKE2/Kubernetes, on the other hand, is typically run across several machines, and each machine
is updated independently. As such, different versions of the package and NixOS module must maintain
compatibility with each other through temporary version skew during updates. The upstream Kubernetes
project documents this in their
[version-skew policy](https://kubernetes.io/releases/version-skew-policy/#supported-component-upgrade-order).

Within Nixpkgs, we strive to maintain a valid "upgrade path" that does not run afoul of the upstream
version skew policy.

> [!NOTE]
> Upgrade the server nodes first, one at a time. Once all servers have been upgraded, you may then
> upgrade agent nodes.

## Release Maintenance

This section describes how new RKE2 releases are published in Nixpkgs.

Before contributing new RKE2 packages or updating existing packages, make sure that

- New packages build (e.g. `nix-build -A rke2_1_34`)
- All tests pass (e.g. `nix-build -A rke2_1_34.tests`)
- You respect the Nixpkgs [contributing guidelines](/CONTRIBUTING.md)

### Release Channels

RKE2 has two named release channels, i.e. `stable` and `latest`. Additionally, there exists a
release channel tied to each Kubernetes minor version, e.g. `v1.32`.

Nixpkgs follows active minor version release channels (typically 4 at a time) and sets aliases for
`rke2_stable` and `rke2_latest` accordingly. The [update-script](./update-script.sh) takes care of
updating the aliases automatically, but these updates **should not be backported** to release
channels as they can cause breakage on multi-node clusters.

For further information visit the
[RKE2 release channels documentation](https://docs.rke2.io/upgrades/manual_upgrade?_highlight=manua#release-channels).

### Patch Releases

Updates to existing packages should be performed by the update script. In order to update an RKE2
package, you call the update script and pass it the minor version of the package you want to update.

For example, to update `rke2_1_34`:

```
./pkgs/applications/networking/cluster/rke2/update-script.sh 34
```

Patch releases for packages that are also available on the latest stable release channel should be
backported. The backport PR can be created automatically by adding the `backport release-XX.XX`
label on the update PR.

### Minor Releases

Every minor release gets a dedicated package in nixpkgs. For example, you would release `rke2_1_35`
by doing the following:

1. Copy the version information of an existing release, its contents will be updated by the update
   script later on
   - `cp -r ./pkgs/applications/networking/cluster/rke2/1_34 ./pkgs/applications/networking/cluster/rke2/1_35`
2. Add a new package block to [default.nix](./default.nix), you can copy an existing block from a
   previous release and update the version numbers
   - `rke2_1_35 = ...`
3. Add the package reference to [pkgs/top-level/all-packages.nix](/pkgs/top-level/all-packages.nix)
4. Run the update script for the new package
   - `./pkgs/applications/networking/cluster/rke2/update-script.sh 35`

New minor versions are **not** backported to stable release channels.

### Final Patch Releases (EOL)

RKE2 follows Kubernetes' release schedule. In general, there is a final patch release with which a
minor version enters end-of-life. See Kubernetes'
[non-active branch history](https://kubernetes.io/releases/patch-releases/#non-active-branch-history)
for further information. Approximately every 4 months a minor RKE2 version reaches EOL.

Due to the delay between Kubernetes releases and RKE2 releases, the final patch version for RKE2 may
be released slightly after the EOL date. Usually this is nothing to worry about.

#### Handling EOL on unstable

EOL packages are removed from unstable. The final patch version should not be released on unstable,
if it has entered end-of-life already.

In order to remove a versioned RKE2 package, create a PR achieving the following:

1. Remove the versioned folder containing the version files
   - `rm -r ./pkgs/applications/networking/cluster/rke2/1_34`
2. Remove the package block from [default.nix](../default.nix) (`rke2_1_34 = ...`)
3. Remove the package reference from
   [pkgs/top-level/all-packages.nix](/pkgs/top-level/all-packages.nix)
4. Add a deprecation notice in [pkgs/top-level/aliases.nix](/pkgs/top-level/aliases.nix)
   - Such as
     `rke2_1_34 = throw "'rke2_1_34' has been removed from Nixpkgs as it has reached end of life"; # Added 2026-10-27`

#### Handling EOL on stable

EOL packages should **not** be removed from a stable release branch. Instead we mark stable EOL
packages as vulnerable due to EOL, like it is also done for EOL JDKs, browser engines, Node.js
versions, etc.

In order to mark a versioned RKE2 package as vulnerable, override `meta.knownVulnerabilities` on the
respective package block.

```nix
{
  rke2_1_34 = (common (import ./1_34/versions.nix) extraArgs).overrideAttrs {
    meta.knownVulnerabilities = [ "rke2_1_34 has reached end-of-life on 2026-10-27" ];
  };
}
```

> [!NOTE]
> Remember to add "Not-cherry-picked-because: <reason>" in the commit message for commits on stable
> that are not cherry picked.

#### Additional Resources

- [RKE2 Product Support Lifecycle page](https://www.suse.com/lifecycle#rke2)
