# Test that attrListOf does not support type merging:
# two declarations of the same option should fail.
{ lib, ... }:
let
  inherit (lib) mkOption types;
in
{
  imports = [
    { options.merged = mkOption { type = types.attrListOf types.str; }; }
    { options.merged = mkOption { type = types.attrListOf types.str; }; }
  ];
}
