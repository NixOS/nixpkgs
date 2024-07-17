{ callPackage }:
{
  ldap = callPackage ./ldap.nix { };
  radius = callPackage ./radius.nix { };
}
