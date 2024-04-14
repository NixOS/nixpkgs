# k3s versions

K3s, Kubernetes, and other clustered software has the property of not being able to update atomically. Most software in nixpkgs, like for example bash, can be updated as part of a "nixos-rebuild switch" without having to worry about the old and the new bash interacting in some way.

K3s/Kubernetes, on the other hand, is typically run across several NixOS machines, and each NixOS machine is updated independently. As such, different versions of the package and NixOS module must maintain compatibility with each other through temporary version skew during updates.

The upstream Kubernetes project [documents this in their version-skew policy](https://kubernetes.io/releases/version-skew-policy/#supported-component-upgrade-order).

Within nixpkgs, we strive to maintain a valid "upgrade path" that does not run
afoul of the upstream version skew policy.

## Upstream release cadence and support

K3s is built on top of K8s, and typically provides a similar release cadence and support window (simply by cherry-picking over k8s patches). As such, we assume k3s's support lifecycle is identical to upstream K8s.

This is documented upstream [here](https://kubernetes.io/releases/patch-releases/#support-period).

In short, a new Kubernetes version is released roughly every 4 months, and each release is supported for a little over 1 year.

Any version that is not supported by upstream should be dropped from nixpkgs.

## Versions in NixOS releases

NixOS releases should avoid having deprecated software, or making major version upgrades, wherever possible.

As such, we would like to have only the newest K3s version in each NixOS
release at the time the release branch is branched off, which will ensure the
K3s version in that release will receive updates for the longest duration
possible.

However, this conflicts with another desire: we would like people to be able to upgrade between NixOS stable releases without needing to make a large enough k3s version jump that they violate the Kubernetes version skew policy.

To give an example, we may have the following timeline for k8s releases:

(Note, the exact versions and dates may be wrong, this is an illustrative example, reality may differ).

```mermaid
gitGraph
    branch k8s
    commit
    branch "k8s-1.24"
    checkout "k8s-1.24"
    commit id: "1.24.0" tag: "2022-05-03"
    branch "k8s-1.25"
    checkout "k8s-1.25"
    commit id: "1.25.0" tag: "2022-08-23"
    branch "k8s-1.26"
    checkout "k8s-1.26"
    commit id: "1.26.0" tag: "2022-12-08"
    checkout k8s-1.24
    commit id: "1.24-EOL" tag: "2023-07-28"
    checkout k8s-1.25
    commit id: "1.25-EOL" tag: "2023-10-27"
    checkout k8s-1.26
    commit id: "1.26-EOL" tag: "2024-02-28"
```

(Note: the above graph will render if you view this markdown on GitHub, or when using [mermaid](https://mermaid.js.org/))

In this scenario even though k3s 1.24 is still technically supported when the NixOS 23.05
release is cut, since it goes EOL before the NixOS 23.11 release is made, we would
not want to include it. Similarly, k3s 1.25 would go EOL before NixOS 23.11.

As such, we should only include k3s 1.26 in the 23.05 release.

We can then make a similar argument when NixOS 23.11 comes around to not
include k3s 1.26 or 1.27. However, that means someone upgrading from the NixOS
22.05 release to the NixOS 23.11 would not have a supported upgrade path.

In order to resolve this issue, we propose backporting not just new patch releases to older NixOS releases, but also new k3s versions, up to one version before the first version that is included in the next NixOS release.

In the above example, where NixOS 23.05 included k3s 1.26, and 23.11 included k3s 1.28, that means we would backport 1.27 to the NixOS 23.05 release, and backport all patches for 1.26 and 1.27.
This would allow someone to upgrade between those NixOS releases in a supported configuration.


## K3s upkeep for nixpkgs maintainers

* A `nixos-stable` release triggers the need of re-setting K3s versions in `nixos-unstable` branch to a single K3s version. After every `nixos-stable` release, K3s maintainers should remove all K3s versions in `nixos-unstable` branch but the latest. While `nixos-stable` keeps the multiple K3s versions necessary for a smooth upgrade to `nixos-unstable`.

* Whenever adding a new major/minor K3s version to nixpkgs:
  - update `k3s` alias to the latest version.
  - add a NixOS release note scheduling the removal of all K3s packages but the latest
  - include migration information from both Kubernetes and K3s projects

* For version patch upgrades, use the K3s update script.

  To execute the update script, from nixpkgs git repository, run:

  > ./pkgs/applications/networking/cluster/k3s/update-script.sh "29"

  "29" being the target minor version to be updated.

  On failure, the update script should be fixed. On failing to fix, open an issue reporting the update script breakage.

  RyanTM bot can automatically do patch upgrades. Update logs are available at: https://r.ryantm.com/log/k3s_1_29/

* When reviewing upgrades, check:

  - At top-level, every K3s version should have the Go compiler pinned according to `go.mod` file.

    Notice the update script does not automatically pin the Go version.

  - K3s passthru.tests (Currently: single-node, multi-node, etcd) works for all architectures (linux-x86_64, aarch64-linux).

    For GitHub CI, [OfBorg](https://github.com/NixOS/ofborg) can be used to test all platforms.

    To test locally, at nixpkgs repository, run:
    > nix build .#k3s_1_29.passthru.tests.{etcd,single-node,multi-node}

    Replace "29" according to the version that you are testing.

  - Read the nix build logs to check for anything unusual. (Obvious but underrated.)

* Thank you for reading the documentation and your continued contribution.
