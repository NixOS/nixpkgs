# Intel GPU Support in k3s

This article makes the following assumptions:
1. `services.k3s.enable` is already set to true
2. The Linux kernel running is modern enough to support your GPU out of the box
3. The desired driver is `i915` -- modify as needed for other drivers

> Note: at the time of writing, the author was using an Intel Arc A770 in k3s. The majority of this guide likely should work on other Kubernetes distributions, and will likely work identically for integrated graphics capabilities.

### Enable the Intel driver in NixOS

Add the following NixOS configuration to enable the Intel driver (necessary on headless deployments):

```
services.xserver.videoDrivers = [ "i915" ];
```

After rebuilding the configuration, reboot the host for the GPU driver to be assigned to the GPU. Use the following command to ensure the GPU is using the i915 kernel:

```
sudo lspci -k
```

i.e. the output looks like this on a host with the Intel Arc A770:

```
❯ sudo lspci -k | grep -A 3 'Arc'
03:00.0 VGA compatible controller: Intel Corporation DG2 [Arc A770] (rev 08)
        Subsystem: ASRock Incorporation Device 6010
        Kernel driver in use: i915
        Kernel modules: i915, xe
```

## Install Intel Node Feature Discovery (NFD) in k3s

Intel's device plugin for kubernetes provides Node Feature Discovery (NFD). NFD allows for GPU capabilities on a node to be automatically discovered if a discrete GPU is installed and the Intel drivers have been properly assigned.

> Documentation for Intel NFD installation is here for reference: [Install with NFD](https://intel.github.io/intel-device-plugins-for-kubernetes/cmd/gpu_plugin/README.html#install-with-nfd)

The following commands will install NFD in the cluster (assumes `curl`, `jq` and `kubectl` are all installed/configured):

```
# Use the latest release
export LATEST_RELEASE=$(curl -s https://api.github.com/repos/intel/intel-device-plugins-for-kubernetes/releases/latest | jq -r '.tag_name')

# Use Kustomize to deploy the configuration
kubectl apply -k "https://github.com/intel/intel-device-plugins-for-kubernetes/deployments/nfd?ref=$LATEST_RELEASE"
kubectl apply -k "https://github.com/intel/intel-device-plugins-for-kubernetes/deployments/nfd/overlays/node-feature-rules?ref=$LATEST_RELEASE"
kubectl apply -k "https://github.com/intel/intel-device-plugins-for-kubernetes/deployments/gpu_plugin/overlays/nfd_labeled_nodes?ref=$LATEST_RELEASE"
```

NFD should automatically apply relevant labels to your node. This can be verified with the following command:

```
kubectl get nodes -o yaml | grep gpu.intel.com | sort -u
```

Output should look similar to the following:

```
❯ kubectl get nodes -o yaml | grep gpu.intel.com | sort -u
      gpu.intel.com/device-id.0300-56a0.count: "1"
      gpu.intel.com/device-id.0300-56a0.present: "true"
      gpu.intel.com/family: A_Series
      gpu.intel.com/i915: "1"
      gpu.intel.com/i915_monitoring: "0"
      nfd.node.kubernetes.io/feature-labels: gpu.intel.com/device-id.0300-56a0.count,gpu.intel.com/device-id.0300-56a0.present,gpu.intel.com/family,intel.feature.node.kubernetes.io/gpu
```

> Note: `gpu.intel.com/i915: "1"` indicates only one pod can use the GPU -- see below for a fix.

Now, GPU-enabled pods can be run with this configuration:

```
spec:
  containers:
    resources:
      requests:
        gpu.intel.com/i915: "1"
      limits:
        gpu.intel.com/i915: "1"
```

### Allowing more than one pod to use the GPU

In the default configuration, only one pod can use the GPU. To enable multiple pods to use the GPU, apply the following Kustomize patch:

```
patches:
- target:
    kind: DaemonSet
    name: intel-gpu-plugin
  patch: |
    - op: add
      path: /spec/template/spec/containers/0/args
      value:
        - -shared-dev-num=10
```

Or, manually edit the `intel-gpu-plugin` DaemonSet to run with `-shared-dev-num=10` (or however many max pods can access the GPU), like so:

```
apiVersion: apps/v1
kind: DaemonSet
metadata:
  name: intel-gpu-plugin
spec:
    spec:
      containers:
      - args:
        - -shared-dev-num=10
```

Verify the number has been applied like so:

```
kubectl get nodes -o yaml | grep gpu.intel.com/i915 | sort -u
```

i.e. in this configuration, up to 10 pods can use the GPU:

```
❯ kubectl get nodes -o yaml | grep gpu.intel.com/i915 | sort -u
    gpu.intel.com/i915: "10"
```

### Test pod

This is a complete pod configuration for reference/testing:

```
---
apiVersion: v1
kind: Pod
metadata:
  name: intel-gpu-test
  namespace: default
spec:
  containers:
  - name: intel-gpu-test
    image: docker.io/ubuntu:24.04
    command: [ "/bin/bash", "-c", "--" ]
    args: [ "while true; do sleep 30; done;" ]
    resources:
      requests:
        gpu.intel.com/i915: "1"
      limits:
        gpu.intel.com/i915: "1"
```

Once the pod is running, use the following command to test that the GPU is available:

```
kubectl exec -n default -it pod/intel-gpu-test -- ls /dev/dri
```

If the GPU is available, the output will look like the following:

```
❯ kubectl exec -n default -it pod/intel-gpu-test -- ls /dev/dri
by-path  card1  renderD128
```

Delete the pod so as to not count against the GPU limit:

```
kubectl delete -n default pod/intel-gpu-test
```
