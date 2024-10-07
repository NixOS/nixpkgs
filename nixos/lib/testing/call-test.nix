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
    # See https://nixos.org/manual/nixos/unstable#sec-override-nixos-test
    # written in nixos/doc/manual/development/writing-nixos-tests.section.md
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
