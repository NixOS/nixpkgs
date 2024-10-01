{ callPackage, authentik }:
{
  ldap = callPackage ./ldap.nix { inherit authentik; };
  radius = callPackage ./radius.nix { inherit authentik; };
}
