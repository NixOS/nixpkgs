{
  config,
  lib,
  options,
  ...
}:
let
  inherit (lib) isAttrs mkOption types;
  nullAttrs = lib.mapAttrs (_: _: null);
in
{
  imports = [
    ./option-meta-required.nix
  ];
  options = {
    foo = lib.mkOption {
      type = lib.types.str;
      meta.required = true;
    };
    undeclared = lib.mkOption {
      type = lib.types.str;
      # typo, no q
      meta.reuired = false;
    };
    missingDef = mkOption {
      type = lib.types.str;
    };
    brokenMeta = mkOption {
      meta = abort "brokenMeta.meta is broken and must not be evaluated as a matter of laziness, performance, robustness.";
      default = "ok";
    };

    assertions = mkOption { };
  };
  config = {
    foo = "bar";
    assertions =
      assert options.foo.meta == { required = true; };
      # laziness
      assert isAttrs options.missingDef.meta;
      assert nullAttrs options.missingDef.meta == { required = null; };
      assert config.brokenMeta == "ok";
      "ok";
  };
}
