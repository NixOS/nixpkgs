# Nvidia GPU Support

To use Nvidia GPU in the cluster the nvidia-container-runtime and runc are needed. To get the two components it suffices to add the following to the configuration

```
virtualisation.docker = {
  enable = true;
  enableNvidia = true;
};
environment.systemPackages = with pkgs; [ docker runc ];
```

Note, using docker here is a workaround, it will install nvidia-container-runtime and that will cause it to be accessible via /run/current-system/sw/bin/nvidia-container-runtime, currently its not directly accessible in nixpkgs.

You now need to create a new file in `/var/lib/rancher/k3s/agent/etc/containerd/config.toml.tmpl` with the following

```
{{ template "base" . }}

[plugins."io.containerd.grpc.v1.cri".containerd.runtimes.nvidia]
  privileged_without_host_devices = false
  runtime_engine = ""
  runtime_root = ""
  runtime_type = "io.containerd.runc.v2"

[plugins."io.containerd.grpc.v1.cri".containerd.runtimes.nvidia.options]
  BinaryName = "/run/current-system/sw/bin/nvidia-container-runtime"
```

Update: As of 12/03/2024 It appears that the last two lines above are added by default, and if the two lines are present (as shown above) it will refuse to start the server. You will need to remove the two lines from that point onward.

Note here we are pointing the nvidia runtime to "/run/current-system/sw/bin/nvidia-container-runtime".

Now apply the following runtime class to k3s cluster:

```
apiVersion: node.k8s.io/v1
handler: nvidia
kind: RuntimeClass
metadata:
  labels:
    app.kubernetes.io/component: gpu-operator
  name: nvidia
```

Following [k8s-device-plugin](https://github.com/NVIDIA/k8s-device-plugin#deployment-via-helm) install the helm chart with `runtimeClassName: nvidia` set. In order to passthrough the nvidia card into the container, your deployments spec must contain - runtimeClassName: nvidia - env:

```
   - name: NVIDIA_VISIBLE_DEVICES
     value: all
   - name: NVIDIA_DRIVER_CAPABILITIES
     value: all
```

to test its working exec onto a pod and run nvidia-smi. For more configurability of nvidia related matters in k3s look in [k3s-docs](https://docs.k3s.io/advanced#nvidia-container-runtime-support).
