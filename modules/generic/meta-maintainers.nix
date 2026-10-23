# Test:
#   ./meta-maintainers/test.nix
{
  # Not `lib.genericModules.meta-maintainers`: the `lib` module argument may come
  # from a different Nixpkgs version than this file.
  imports = [ ../../lib/modules/generic/meta-maintainers.nix ];
}
