# K3s Usage

## Single Node

```
{
  networking.firewall.allowedTCPPorts = [
    6443 # k3s: required so that pods can reach the API server (running on port 6443 by default)
    # 2379 # k3s, etcd clients: required if using a "High Availability Embedded etcd" configuration
    # 2380 # k3s, etcd peers: required if using a "High Availability Embedded etcd" configuration
  ];
  networking.firewall.allowedUDPPorts = [
    # 8472 # k3s, flannel: required if using multi-node for inter-node networking
  ];
  services.k3s.enable = true;
  services.k3s.role = "server";
  services.k3s.extraFlags = toString [
    # "--debug" # Optionally add additional args to k3s
  ];
}
```

Once the above changes are active, you can access your cluster through `sudo k3s kubectl` (e.g. `sudo k3s kubectl cluster-info`) or by using the generated kubeconfig file in `/etc/rancher/k3s/k3s.yaml`.
Multi-node setup

## Multi-Node

it is simple to create a cluster of multiple nodes in a highly available setup (all nodes are in the control-plane and are a part of the etcd cluster).

The first node is configured like this:

```
{
  services.k3s = {
    enable = true;
    role = "server";
    token = "<randomized common secret>";
    clusterInit = true;
  };
}
```

Any other subsequent nodes can be added with a slightly different config:

```
{
  services.k3s = {
    enable = true;
    role = "server"; # Or "agent" for worker only nodes
    token = "<randomized common secret>";
    serverAddr = "https://<ip of first node>:6443";
  };
}
```

For this to work you need to open the aforementioned API, etcd, and flannel ports in the firewall. Official documentation on what ports need to be opened for specific use cases can be found on [k3s' documentation site](https://docs.k3s.io/installation/requirements#inbound-rules-for-k3s-nodes). Note that it is [recommended](https://etcd.io/docs/v3.3/faq/#why-an-odd-number-of-cluster-members) to use an odd number of nodes in such a cluster.

Tip: If you run into connectivity issues between nodes for specific applications (e.g. ingress controller), please verify the firewall settings you have enabled (example under [Single Node](#single-node)) against the documentation for that specific application. In the ingress controller example, you may want to open 443 or 80 depending on your use case.

## Quirks

### `prefer-bundled-bin`

K3s has a config setting `prefer-bundled-bin` (and CLI flag `--prefer-bundled-bin`) that makes k3s use binaries from the `/var/lib/rancher/k3s/data/current/bin/aux/` directory, as unpacked by the k3s binary, before the system `$PATH`.
This works with the official distribution of k3s but not with the package from nixpkgs, as it does not bundle the upstream binaries from [`k3s-root`](https://github.com/k3s-io/k3s-root) into the k3s binary.
Thus the `prefer-bundled-bin` setting **cannot** be used to work around issues (like [this `mount` regression](https://github.com/util-linux/util-linux/issues/3474)) with binaries used/called by the kubelet.

### Building from a different source

Because the package is split into multiple derivations and the build process is generally more complex, it is not very obvious how to build k3s from a different source (fork or arbitrary commit).

To build k3s from a different source, you must use `.override` together with `overrideBundleAttrs` (for the k3sBundle derivation) and another `.overrideAttrs` (for the final derivation):

```nix
{ fetchgit, k3s }:
let
  k3sRepo = fetchgit {
    url = "https://github.com/k3s-io/k3s";
    rev = "99d91538b1327da933356c318dc8040335fbb66c";
    hash = "sha256-vVqZzVp0Tea27s8HDVq4SgqlbHBdZcFzNKmPFi0Yktk=";
  };
  vendorHash = "sha256-jrPVY+FVZV9wlbik/I35W8ChcLrHlYbLAwUYU16mJLM=";
in
(k3s.override {
  overrideBundleAttrs = {
    src = k3sRepo;
    inherit vendorHash;
  };
}).overrideAttrs
  {
    src = k3sRepo;
    inherit vendorHash;
  }
```

- Additionally to `overrideBundleAttrs` there are also: `overrideCniPluginsAttrs` and `overrideContainerdAttrs`.
- `k3s --version` still prints the commit SHA (`k3sCommit` passed into `builder.nix`) from the "base" package instead of the actually used `rev`.
- Depending on the changes made in the fork / commit, the `k3s.override` (without the `overrideAttrs` of the final derivation) might already be enough.
- If the commit is for a different version of k3s, make sure to use the correct "base" package, e.g., `k3s_1_31.override`. Otherwise the build fails with `Tagged version 'v1.33.1+k3s1' does not match expected version 'v1.31.9[+-]*'`
- When adding an entirely new k3s version by calling `builder.nix`, keep in mind that the `k3sCommit` parameter is not used as the `k3sRepo` `rev` (it uses `v${k3sVersion}`). Therefore, you additionally must override the package, as shown above.
