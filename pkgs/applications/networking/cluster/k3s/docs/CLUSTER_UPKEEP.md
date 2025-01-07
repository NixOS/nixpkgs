
# K3s Upkeep for Users

General documentation for the K3s user for cluster tasks and troubleshooting steps.

## Upkeep

### Changing K3s Token

Changing the K3s token requires resetting cluster. To reset the cluster, you must do the following:

#### Stopping K3s

Disabling K3s NixOS module won't stop K3s related dependencies, such as containerd or networking. For stopping everything, either run "k3s-killall.sh" script (available on $PATH under `/run/current-system/sw/bin/k3s-killall.sh`) or reboot host.

### Syncing K3s in multiple hosts

Nix automatically syncs hosts to `configuration.nix`, for syncing configuration.nix's git repository and triggering `nixos-rebuild switch` in multiple hosts, it is commonly used `ansible`, which enables automation of cluster provisioning, upgrade and reset.

### Cluster Reset

As upstream "k3s-uninstall.sh" is yet to be packaged for NixOS, it's necessary to run manual steps for resetting cluster.

Disable K3s instances in **all** hosts:

In NixOS configuration, set:
```
 services.k3s.enable = false;
```
Rebuild NixOS. This is going to remove K3s service files. But it won't delete K3s data.

To delete K3s files:

Dismount kubelet:
```
 KUBELET_PATH=$(mount | grep kubelet | cut -d' ' -f3);
 ${KUBELET_PATH:+umount $KUBELET_PATH}
```
Delete k3s data:
```
 rm -rf /etc/rancher/{k3s,node};
 rm -rf /var/lib/{rancher/k3s,kubelet,longhorn,etcd,cni}
```
When using Etcd, Reset Etcd:

Certify **all** K3s instances are stopped, because a single instance can re-seed etcd database with previous cryptographic key.

Disable etcd database in NixOS configuration:
```
 services.etcd.enable = false;
```
Rebuild NixOS.

Delete etcd files:
```
 rm -rf /var/lib/etcd/
```
Reboot hosts.

In NixOS configuration:
```
 Re-enable Etcd first. Rebuild NixOS. Certify service health. (systemctl status etcd)
 Re-enable K3s second. Rebuild NixOS. Certify service health. (systemctl status k3s)
```
Etcd & K3s cluster will be provisioned new.

Tip: Use Ansible to automate reset routine, like this.

## Troubleshooting

### Raspberry Pi not working

If the k3s.service/k3s server does not start and gives you the error FATA[0000] failed to find memory cgroup (v2) Here's the github issue: https://github.com/k3s-io/k3s/issues/2067 .

To fix the problem, you can add these things to your configuration.nix.
```
  boot.kernelParams = [
    "cgroup_enable=cpuset" "cgroup_memory=1" "cgroup_enable=memory"
  ];
```

### FailedKillPod: failed to get network "cbr0" cached result

> KillPodSandboxError: failed to get network "cbr0" cached result: decoding version from network config: unexpected end of JSON input

Workaround: https://github.com/k3s-io/k3s/issues/6185#issuecomment-1581245331
