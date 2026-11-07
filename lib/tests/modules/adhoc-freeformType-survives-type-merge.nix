{ lib, ... }:
{
  options.dummy = lib.mkOption {
    type = lib.types.anything;
    default = { };
  };
  freeformType =
    let
      a = lib.types.attrsOf (lib.types.submodule { options.bar = lib.mkOption { }; });
    in
    # modifying types like this breaks type merging.
    # This test makes sure that type merging is not performed when only a single declaration exists.
    # Don't modify types in practice!
    a
    // {
      merge = loc: defs: { freeformItems = a.merge loc defs; };
    };
  config.foo.bar = "ok";
}
