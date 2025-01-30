
# K3s Upkeep for Maintainers

General documentation for the K3s maintainer and reviewer use for consistency in maintenance processes.

## NixOS Release Maintenance

This process split into two sections and adheres to the versioning policy outlined in [VERSIONING.md](VERSIONING.md).

### Pre-Release

* Prior to the breaking change window of the next release being closed:
  * `nixos-unstable`: Ensure k3s points to latest versioned release
  * `nixos-unstable`: Ensure release notes are up to date
  * `nixos-unstable`: Remove k3s releases which will be end of life upstream prior to end-of-life for the next NixOS stable release are removed with proper deprecation notice (process listed below)

### Post-Release

* For major/minor releases of k3s:
  * `nixos-unstable`: Create a new versioned k3s package
  * `nixos-unstable`: Update k3s alias to point to new versioned k3s package
  * `nixos-unstable`: Add NixOS Release note denoting:
    * Removal of deprecated K3s packages
    * Migration information from the Kubernetes and K3s projects
  * `nixos-stable`: Backport the versioned package
* For patch releases of existing packages:
  * `nixos-unstable`: Update package version (process listed below)
  * `nixos-stable`: Backport package update done to nixos-unstable

## Patch Upgrade Process

Patch upgrades can use the [update script](../update-script.sh) in the root of the package. To update k3s 1.30.x, for example, you can run the following from the root of the nixpkgs git repo:

> ./pkgs/applications/networking/cluster/k3s/update-script.sh "30"

To update another version, just replace the `"30"` with the appropriate minor revision.

If the script should fail, the first goal would be to fix the script. If you are unable to fix the script, open an issue reporting the update script failure with the exact command used and the failure observed.

RyanTM bot can automatically do patch upgrades. Update logs are available at versioned urls, e.g. for 1.30.x: https://r.ryantm.com/log/k3s_1_30

## Package Removal Process

Package removal policy and timelines follow our reasoning in the [versioning documentation](VERSIONING.md#patch-release-support-lifecycle). In order to remove a versioned k3s package, create a PR achieving the following:

* Remove the versioned folder containing the chart and package version files (e.g. `./1_30/`)
* Remove the package block from [default.nix](../default.nix) (e.g. `k3s_1_30 = ...`)
* Remove the package reference from [pkgs/top-level/all-packages.nix](/pkgs/top-level/all-packages.nix)
* Add a deprecation notice in [pkgs/top-level/aliases.nix](/pkgs/top-level/aliases.nix), such as `k3s_1_26 = throw "'k3s_1_26' has been removed from nixpkgs as it has reached end of life"; # Added 2024-05-20`.

## Change Request Review Process

Quick checklist for reviewers of the k3s package:

* Is the version of the Go compiler pinned according to the go.mod file for the release?
  * Update script will not pin nor change the go version.
* Do the K3s passthru.tests work for all architectures supported? (linux-x86_64, aarch64-linux)
  * For GitHub CI, [OfBorg](https://github.com/NixOS/ofborg) can be used to test all platforms.
  * For Local testing, the following can be run in nixpkgs root on the upgrade branch: `nix build .#k3s_1_29.passthru.tests.{etcd,single-node,multi-node}` (Replace "29" to the version tested)
* Anything unusual in the nix build logs or test logs?
