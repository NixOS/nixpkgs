{ lib, ... }:
{
  # Proper type would be attrsOf (either int str)
  # This checks backwards compatibility for the incorrect usage of either
  freeformType = lib.types.either lib.types.int lib.types.str;
  foo = "bar";
}
