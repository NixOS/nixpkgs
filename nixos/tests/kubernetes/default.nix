{ system ? builtins.currentSystem }:
{
  dns = import ./dns.nix { inherit system; };
  # e2e = import ./e2e.nix { inherit system; };  # TODO: make it pass
  # the following test(s) can be removed when e2e is working:
  rbac = import ./rbac.nix { inherit system; };
}
