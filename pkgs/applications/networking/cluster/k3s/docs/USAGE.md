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
