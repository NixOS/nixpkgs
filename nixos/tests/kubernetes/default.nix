{ system ? builtins.currentSystem }:
{
    kubernetes-singlenode = import ./singlenode.nix { inherit system; };
    kubernetes-multinode-kubectl = import ./multinode-kubectl.nix { inherit system; };
    kubernetes-rbac = import ./rbac.nix { inherit system; };
    kubernetes-dns = import ./dns.nix { inherit system; };
}
