{
  config,
  extendModules,
  lib,
  ...
}:
let
  inherit (lib) mkOption types;

  unsafeGetAttrPosStringOr =
    default: name: value:
    let
      p = builtins.unsafeGetAttrPos name value;
    in
    if p == null then default else p.file + ":" + toString p.line + ":" + toString p.column;

in
{
  options = {
    result = mkOption {
      internal = true;
      default = config;
    };
  };
  config = {
    # Docs: nixos/doc/manual/development/writing-nixos-tests.section.md
    /**
      See https://nixos.org/manual/nixos/unstable#sec-override-nixos-test
    */
    passthru.extend =
      args@{
        modules,
        specialArgs ? { },
      }:
      (extendModules {
        inherit specialArgs;
        modules = map (lib.setDefaultModuleLocation (
          unsafeGetAttrPosStringOr "<test.extend module>" "modules" args
        )) modules;
      }).config.test;
  };
}
