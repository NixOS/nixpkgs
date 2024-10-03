{ callPackage, authentik }: {
  ldap = callPackage ./ldap.nix { authentik = authentik; };
  proxy = callPackage ./proxy.nix { authentik = authentik; };
  radius = callPackage ./radius.nix { authentik = authentik; };
}
