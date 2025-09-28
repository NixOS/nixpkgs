# RKE2 Version

RKE2, Kubernetes, and other clustered software has the property of not being able to update
atomically. Most software in nixpkgs, like for example bash, can be updated as part of a
`nixos-rebuild switch` without having to worry about the old and the new bash interacting in some
way. RKE2/Kubernetes, on the other hand, is typically run across several machines, and each machine
is updated independently. As such, different versions of the package and NixOS module must maintain
compatibility with each other through temporary version skew during updates. The upstream Kubernetes
project documents this in their
[version-skew policy](https://kubernetes.io/releases/version-skew-policy/#supported-component-upgrade-order).

Within nixpkgs, we strive to maintain a valid "upgrade path" that does not run afoul of the upstream
version skew policy.

> [!NOTE]
> Upgrade the server nodes first, one at a time. Once all servers have been upgraded, you may then
> upgrade agent nodes.

## Release Channels

RKE2 has two named release channels, i.e. `stable` and `latest`. Additionally, there exists a
release channel tied to each Kubernetes minor version, e.g. `v1.32`.

Nixpkgs follows active minor version release channels (typically 4 at a time) and sets aliases for
`rke2_stable` and `rke2_latest` accordingly.

Patch releases should be backported to the latest stable release branch; however, new minor
versions are not backported.

For further information visit the
[RKE2 release channels documentation](https://docs.rke2.io/upgrades/manual_upgrade?_highlight=manua#release-channels).

## EOL Versions

Approximately every 4 months a minor RKE2 version reaches EOL. EOL versions should be removed from
`nixpkgs-unstable`, preferably by throwing with an explanatory message in
`pkgs/top-level/aliases.nix`. With stable releases, however, it isn't expected that packages will be
removed. Instead we set `meta.knownVulnerabilities` for stable EOL packages, like it is also done
for EOL JDKs, browser engines, Node.js versions, etc.

For further information on the RKE2 lifecycle, see the
[SUSE Product Support Lifecycle page](https://www.suse.com/lifecycle#rke2).
