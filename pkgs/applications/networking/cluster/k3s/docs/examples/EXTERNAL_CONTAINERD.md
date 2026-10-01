# Using an external Containerd

K3s ships with its own containerd binary, however, sometimes it's necessary to use an external
containerd. This can be done in a few lines of configuration.

## Configure Containerd

```nix
{
  virtualisation.containerd = {
    enable = true;
    settings.plugins."io.containerd.grpc.v1.cri".cni = {
      bin_dir = "/var/lib/rancher/k3s/data/current/bin";
      conf_dir = "/var/lib/rancher/k3s/agent/etc/cni/net.d";
    };
    # Optionally, configure containerd to use the k3s pause image
    settings.plugins."io.containerd.grpc.v1.cri" = {
      sandbox_image = "docker.io/rancher/mirrored-pause:3.6";
    };
  };
}
```

## Configure k3s

```nix
{
  services.k3s = {
    enable = true;
    extraFlags = [ "--container-runtime-endpoint unix:///run/containerd/containerd.sock" ];
  };
}
```

## Importing Container Images

K3s provides the `services.k3s.images` option to import container images at startup. This option
does **not** work with an external containerd, but you can import the images via
`ctr -n=k8s.io image import /var/lib/rancher/k3s/agent/images/*`. Note that you need to set the
`k8s.io` namespace to make the images available to the cluster.
