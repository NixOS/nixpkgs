# This is an old placeholder file that gets referenced from
# /etc/nixos/configuration.nix (instead of a symlink.)
#
# Can be removed once the new way has been deployed everywhere.
{ ...}:
{
    imports = [./default.nix];
}
