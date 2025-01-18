# Versioning

K3s, Kubernetes, and other clustered software has the property of not being able to update atomically. Most software in nixpkgs, like for example bash, can be updated as part of a "nixos-rebuild switch" without having to worry about the old and the new bash interacting in some way.

K3s/Kubernetes, on the other hand, is typically run across several NixOS machines, and each NixOS machine is updated independently. As such, different versions of the package and NixOS module must maintain compatibility with each other through temporary version skew during updates.

The upstream Kubernetes project [documents this in their version-skew policy](https://kubernetes.io/releases/version-skew-policy/#supported-component-upgrade-order).

Within nixpkgs, we strive to maintain a valid "upgrade path" that does not run
afoul of the upstream version skew policy.

## Patch Release Support Lifecycle

K3s is built on top of K8s and typically provides a similar release cadence and support window (simply by cherry-picking over k8s patches). As such, we assume k3s's support lifecycle is identical to upstream K8s. The upstream K8s release and support lifecycle, including maintenance and end-of-life dates for current releases, is documented [on their support site](https://kubernetes.io/releases/patch-releases/#support-period). A more tabular view of the current support timeline can also be found on [endoflife.date](https://endoflife.date/kubernetes).

In short, a new Kubernetes version is released roughly every 4 months and each release is supported for a little over 1 year.

## Versioning in nixpkgs

There are two package types that are maintained within nixpkgs when we are looking at the `nixos-unstable` branch. A standard `k3s` package and versioned releases such as `k3s_1_28`, `k3s_1_29`, and `k3s_1_30`.

The standard `k3s` package will be updated as new versions of k3s are released upstream. Versioned releases, on the other hand, will follow the path release support lifecycle as detailed in the previous section and be removed from `nixos-unstable` when they are either end-of-life upstream or older than the current `k3s` package in `nixos-stable`.

## Versioning in NixOS Releases

Those same package types are also maintained on the release branches of NixOS, but have some special considerations within a release.

NixOS releases (24.05, 24.11, etc) should avoid having deprecated software or major version upgrades during the support lifecycle of that release wherever possible. As such, each NixOS release should only ever have one version of `k3s` when it is released. An example for the NixOS 24.05 release would be that `k3s` package points to `k3s_1_30` for the full lifecycle of its release with no other versions present at release.

However, this conflicts with our desire for users to be able to upgrade between stable NixOS releases without needing to make a large enough k3s version jump as to violate the skew policy listed previously. Given NixOS 24.05 has 1.30.x as its k3s version and the NixOS 24.11 release would have 1.32.x as its k3s version, we need to provide a way for users to upgrade k3s to 1.32.x before upgrading to the next NixOS stable release.

To be able to achieve the goal above, the k3s maintainers would backport `k3s_1_31` and `k3s_1_32` from `nixos-unstable` to NixOS 24.05 as they release. This means that when NixOS 24.11 is released with only the `k3s` package pointing to `k3s_1_32`, users will have an upgrade path on 24.05 to first upgrade locally to `k3s_1_31` and then to `k3s_1_32` (e.g. pointing `services.k3s.package` from `k3s` to `k3s_1_31`, upgrading the cluster, and repeating the process through versions).

Using the above as the example, a three NixOS release example would look like:

* NixOS 23.11
  * k3s/k3s_1_27 (Release Version, patches backported)
  * k3s_1_28 (Backported)
  * k3s_1_29 (Backported)
  * k3s_1_30 (Backported)
* NixOS 24.05
  * k3s/k3s_1_30 (Release Version, patches backported)
  * k3s_1_31 (Backported)
  * k3s_1_32 (Backported)
* NixOS 24.11
  * k3s/k3s_1_32 (Release Version, patches backported)
