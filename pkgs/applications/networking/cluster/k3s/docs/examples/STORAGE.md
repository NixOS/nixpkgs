# Storage Examples

The following are some NixOS specific considerations for specific storage mechanisms with kubernetes/k3s.

## Longhorn

NixOS configuration required for Longhorn:

```
environment.systemPackages = [ pkgs.nfs-utils ];
services.openiscsi = {
  enable = true;
  name = "${config.networking.hostName}-initiatorhost";
};
```

Longhorn container has trouble with NixOS path. Solution is to override PATH environment variable, such as:

```
PATH: /usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/run/wrappers/bin:/nix/var/nix/profiles/default/bin:/run/current-system/sw/bin
```

**Kyverno Policy for Fixing Longhorn Container for NixOS**

```
---
apiVersion: v1
kind: ConfigMap
metadata:
  name: longhorn-nixos-path
  namespace: longhorn-system
data:
  PATH: /usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/run/wrappers/bin:/nix/var/nix/profiles/default/bin:/run/current-system/sw/bin
---
apiVersion: kyverno.io/v1
kind: ClusterPolicy
metadata:
  name: longhorn-add-nixos-path
  annotations:
    policies.kyverno.io/title: Add Environment Variables from ConfigMap
    policies.kyverno.io/subject: Pod
    policies.kyverno.io/category: Other
    policies.kyverno.io/description: >-
      Longhorn invokes executables on the host system, and needs
      to be aware of the host systems PATH. This modifies all
      deployments such that the PATH is explicitly set to support
      NixOS based systems.
spec:
  rules:
    - name: add-env-vars
      match:
        resources:
          kinds:
            - Pod
          namespaces:
            - longhorn-system
      mutate:
        patchStrategicMerge:
          spec:
            initContainers:
              - (name): "*"
                envFrom:
                  - configMapRef:
                      name: longhorn-nixos-path
            containers:
              - (name): "*"
                envFrom:
                  - configMapRef:
                      name: longhorn-nixos-path
---
```

## NFS

NixOS configuration required for NFS:

```
boot.supportedFilesystems = [ "nfs" ];
services.rpcbind.enable = true;
```

## Rook/Ceph

In order to support Rook/Ceph, the following NixOS kernelModule configuration is required:

```
  boot.kernelModules = [ "rbd" ];
```

## ZFS ContainerD Support

The [ZFS snapshotter](https://github.com/containerd/zfs) can be enabled for k3s' embedded ContainerD though it requires mounting a dataset to a specific path used by k3s: `/var/lib/rancher/k3s/agent/containerd/io.containerd.snapshotter.v1.zfs`

For example:

```bash
$ zfs create -o mountpoint=/var/lib/rancher/k3s/agent/containerd/io.containerd.snapshotter.v1.zfs <zpool name>/containerd
```

You can now configure k3s to use zfs by passing the `--snapshotter` flag.

```
services.k3s = {
  ...
  extraFlags = [
    "--snapshotter=zfs"
  ];
```
