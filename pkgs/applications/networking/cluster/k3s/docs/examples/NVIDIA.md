# Nvidia GPU Support

> Note: this article assumes `services.k3s.enable = true;` is already set

## Enable the Nvidia driver

```
hardware.nvidia = {
  open = true;
  package = config.boot.kernelPackages.nvidiaPackages.stable; # change to match your kernel
  nvidiaSettings = true;
};

# Hack for getting the nvidia driver recognized
services.xserver = {
  enable = false;
  videoDrivers = [ "nvidia" ];
};

nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [
  "nvidia-x11"
  "nvidia-settings"
];
```

Also, enable the Nvidia container toolkit:

```
hardware.nvidia-container-toolkit.enable = true;
hardware.nvidia-container-toolkit.mount-nvidia-executables = true;

environment.systemPackages = with pkgs; [
  nvidia-container-toolkit
];
```

Rebuild your NixOS configuration.

### Verify that the GPU is accessible

Use the following command to ensure the GPU is accessible:

```
nvidia-smi
```

If there is an error in the output, a reboot may be required for the driver to be assigned to the GPU.

Additionally, `lspci -k` can be used to ensure the driver has been assigned to the GPU:

```
# lspci -k | grep -i nvidia

01:00.0 VGA compatible controller: NVIDIA Corporation TU106 [GeForce RTX 2060 Rev. A] (rev a1)
  Kernel driver in use: nvidia
  Kernel modules: nvidiafb, nouveau, nvidia_drm, nvidia
```

## Configure k3s

You now need to create a new file in `/var/lib/rancher/k3s/agent/etc/containerd/config.toml.tmpl` with the following

```
{{ template "base" . }}

[plugins."io.containerd.grpc.v1.cri".containerd.runtimes.nvidia]
  privileged_without_host_devices = false
  runtime_engine = ""
  runtime_root = ""
  runtime_type = "io.containerd.runc.v2"
```

Now apply the following runtime class to k3s cluster:

```yaml
apiVersion: node.k8s.io/v1
handler: nvidia
kind: RuntimeClass
metadata:
  labels:
    app.kubernetes.io/component: gpu-operator
  name: nvidia
```

Restart k3s:

```
systemctl restart k3s.service
```

Ensure that the Nvidia runtime is detected by k3s:

```
grep nvidia /var/lib/rancher/k3s/agent/etc/containerd/config.toml
```

Apply the DaemonSet in the [generic-cdi-plugin README](https://github.com/OlfillasOdikno/generic-cdi-plugin):

```
apiVersion: v1
kind: Namespace
metadata:
  name: generic-cdi-plugin
---
apiVersion: apps/v1
kind: DaemonSet
metadata:
  name: generic-cdi-plugin-daemonset
  namespace: generic-cdi-plugin
spec:
  selector:
    matchLabels:
      name: generic-cdi-plugin
  template:
    metadata:
      labels:
        name: generic-cdi-plugin
        app.kubernetes.io/component: generic-cdi-plugin
        app.kubernetes.io/name: generic-cdi-plugin
    spec:
      containers:
      - image: ghcr.io/olfillasodikno/generic-cdi-plugin:main
        name: generic-cdi-plugin
        command:
          - /generic-cdi-plugin
          - /var/run/cdi/nvidia-container-toolkit.json
        imagePullPolicy: Always
        securityContext:
          privileged: true
        tty: true
        volumeMounts:
        - name: kubelet
          mountPath: /var/lib/kubelet
        - name: nvidia-container-toolkit
          mountPath: /var/run/cdi/nvidia-container-toolkit.json
      volumes:
      - name: kubelet
        hostPath:
          path: /var/lib/kubelet
      - name: nvidia-container-toolkit
        hostPath:
          path: /var/run/cdi/nvidia-container-toolkit.json
      affinity:
        nodeAffinity:
          requiredDuringSchedulingIgnoredDuringExecution:
            nodeSelectorTerms:
            - matchExpressions:
              - key: "nixos-nvidia-cdi"
                operator: In
                values:
                - "enabled"
```

Apply the following node label (replace `#CHANGEME` with your node name):

```
kind: Node
apiVersion: v1
metadata:
  name: #CHANGEME
  labels:
    nixos-nvidia-cdi: enabled
```

Now, GPU-enabled pods can be run with this configuration:

```
spec:
  runtimeClassName: nvidia
  containers:
    resources:
      requests:
        nvidia.com/gpu-all: "1"
      limits:
        nvidia.com/gpu-all: "1"
```

### Test pod

This is a complete pod configuration for reference/testing:

```
---
apiVersion: v1
kind: Pod
metadata:
  name: gpu-test
  namespace: default
spec:
  runtimeClassName: nvidia # <- THIS FOR GPU
  containers:
  - name: gpu-test
    image: nvidia/cuda:12.6.3-base-ubuntu22.04
    command: [ "/bin/bash", "-c", "--" ]
    args: [ "while true; do sleep 30; done;" ]
    env:
      - name: NVIDIA_VISIBLE_DEVICES
        value: all
      - name: NVIDIA_DRIVER_CAPABILITIES
        value: all
    resources: # <- THIS FOR GPU
      requests:
        nvidia.com/gpu-all: "1"
      limits:
        nvidia.com/gpu-all: "1"
```

Once the pod is running, use the following command to test that the GPU was detected:

```
kubectl exec -n default -it pod/gpu-test -- nvidia-smi
```

If successful, the output will look like the following:

```
Thu Sep 25 04:17:42 2025

+-----------------------------------------------------------------------------------------+

| NVIDIA-SMI 580.82.09              Driver Version: 580.82.09      CUDA Version: 13.0     |

+-----------------------------------------+------------------------+----------------------+

| GPU  Name                 Persistence-M | Bus-Id          Disp.A | Volatile Uncorr. ECC |

| Fan  Temp   Perf          Pwr:Usage/Cap |           Memory-Usage | GPU-Util  Compute M. |

|                                         |                        |               MIG M. |

|=========================================+========================+======================|

|   0  NVIDIA GeForce RTX 2060        Off |   00000000:01:00.0  On |                  N/A |

|  0%   36C    P8             10W /  190W |     104MiB /   6144MiB |      0%      Default |

|                                         |                        |                  N/A |

+-----------------------------------------+------------------------+----------------------+



+-----------------------------------------------------------------------------------------+

| Processes:                                                                              |

|  GPU   GI   CI              PID   Type   Process name                        GPU Memory |

|        ID   ID                                                               Usage      |

|=========================================================================================|

|  No running processes found                                                             |

+-----------------------------------------------------------------------------------------+
```
