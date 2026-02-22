{
  callPackage,
  authentik,
  apiGoVendorHook ? authentik.apiGoVendorHook,
  vendorHash ? authentik.proxy.vendorHash,
}:
{
  ldap = callPackage ./ldap.nix { inherit apiGoVendorHook vendorHash; };
  proxy = callPackage ./proxy.nix { inherit apiGoVendorHook vendorHash; };
  radius = callPackage ./radius.nix { inherit apiGoVendorHook vendorHash; };
}
