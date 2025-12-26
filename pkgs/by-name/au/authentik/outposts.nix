{
  callPackage,
  authentik,
  vendorHash ? authentik.proxy.vendorHash,
}:
{
  ldap = callPackage ./ldap.nix { inherit vendorHash; };
  proxy = callPackage ./proxy.nix { inherit vendorHash; };
  radius = callPackage ./radius.nix { inherit vendorHash; };
}
