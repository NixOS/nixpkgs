{ lib, ... }:
{
  options.dummy = lib.mkOption {
    type = lib.types.anything;
    default = { };
  };
  freeformType =
    let
      a = lib.types.attrsOf lib.types.anything;
    in
    # Modifying types like this is unsafe. Type merging or using a submodule type will discard those modifications.
    # This test makes sure that type.merge can return definitions that don't intersect with the original definitions (unmatchedDefns).
    # Don't modify types in practice!
    a
    // {
      merge = loc: defs: { freeformItems = a.merge loc defs; };
    };
  config.foo.bar = "ok";
}
