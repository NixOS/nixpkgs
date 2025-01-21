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

## ZFS Snapshot Support

K3s's builtin containerd does not support the zfs snapshotter. However, it is possible to configure it to use an external containerd:

```
virtualisation.containerd = {
  enable = true;
  settings =
    let
      fullCNIPlugins = pkgs.buildEnv {
        name = "full-cni";
        paths = with pkgs;[
          cni-plugins
          cni-plugin-flannel
        ];
      };
    in {
      plugins."io.containerd.grpc.v1.cri".cni = {
        bin_dir = "${fullCNIPlugins}/bin";
        conf_dir = "/var/lib/rancher/k3s/agent/etc/cni/net.d/";
      };
      # Optionally set private registry credentials here instead of using /etc/rancher/k3s/registries.yaml
      # plugins."io.containerd.grpc.v1.cri".registry.configs."registry.example.com".auth = {
      #  username = "";
      #  password = "";
      # };
    };
};
# TODO describe how to enable zfs snapshotter in containerd
services.k3s.extraFlags = toString [
  "--container-runtime-endpoint unix:///run/containerd/containerd.sock"
];
```
