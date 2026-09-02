# Using a single instance of nixpkgs makes test evaluation faster.
# To make sure we don't accidentally depend on a modified pkgs, we make the
# related options read-only. We need to test the right configuration.
#
# If your service depends on a nixpkgs setting, first try to avoid that, but
# otherwise, you can remove the readOnlyPkgs import and test your service as
# usual.

# TODO: We currently accept this for nixosTests, so that the `pkgs` argument
#       is consistent with `pkgs` in `pkgs.nixosTests`. Can we reinitialize
#       it with `allowAliases = false`?
# warnIf pkgs.config.allowAliases "nixosTests: pkgs includes aliases."
{ hostPkgs, ... }:
{
  _class = "nixosTest";
  node.pkgs = hostPkgs.pkgsLinux;
}
