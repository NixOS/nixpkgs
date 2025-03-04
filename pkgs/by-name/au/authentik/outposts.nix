{ callPackage }:
{
  ldap = callPackage ./ldap.nix { };
  proxy = callPackage ./proxy.nix { };
  radius = callPackage ./radius.nix { };
}
