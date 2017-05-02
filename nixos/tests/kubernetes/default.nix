{ }:
{
    kubernetes-singlenode = import ./singlenode.nix {};
    kubernetes-multinode-kubectl = import ./multinode-kubectl.nix {};
    kubernetes-rbac = import ./rbac.nix {};
    kubernetes-dns = import ./dns.nix {};
}
